//
//  MoviesScreenViewController.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class MoviesScreenViewController: UIViewController {
    @IBOutlet var movieScreenView: MoviesScreenView! {
        didSet {
            movieScreenView.backgroundColor = .white
        }
    }
    var popularMoviesArray = [PopularMovies]()
    var searchResults = [SearchResult]()
    var searchMovieMode: Bool = false
    var baseImgUrl = "https://image.tmdb.org/t/p/w500"
    override func viewDidLoad() {
        super.viewDidLoad()
        movieScreenView.collectionView.delegate = self
        movieScreenView.collectionView.dataSource = self
        movieScreenView.textField.delegate = self
        Task {
            await getPopularMovies()
        }
    }
    
    func getPopularMovies() async {
        do {
            let moviesResponse: MovieResponse = try await NetworkManager.shared.request(
                target: AppRouter.popularMovies,
                decodable: MovieResponse.self
            )
            
            print("Fetched \(moviesResponse.results.count) movies")
            popularMoviesArray = moviesResponse.results
            movieScreenView.collectionView.reloadData()
        } catch {
            print("Error fetching popular movies: \(error)")
        }
    }
    
    func presentMovieScreen() {
        let movieDeatilsScreenVC = MovieDetaisViewViewController()
        self.navigationController?.pushViewController(movieDeatilsScreenVC, animated: true)
    }
    
    func formatDate(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func searchForMovies(textQuery: String) async {
        do {
            let searchResponse: SearchResponse = try await NetworkManager.shared.request(
                target: AppRouter.searchMovie(textQuery: textQuery),
                decodable: SearchResponse.self
            )
            let filteredResults = searchResponse.results.filter { $0.mediaType == "movie"}
            searchResults = filteredResults
            movieScreenView.collectionView.reloadData()
            print("Found \(filteredResults) results")
        } catch {
            print("Error searching movies:", error)
        }
    }
    
    func fetchMovieDetail(id: Int) async {
        do {
            let movieDetail: MovieDetail = try await NetworkManager.shared.request(
                target: AppRouter.movieDetail(id: id),
                decodable: MovieDetail.self
            )
            
            print("Title: \(String(describing: movieDetail.title))")
            print("Overview: \(movieDetail.overview ?? "N/A")")
            print("Release Date: \(movieDetail.releaseDate ?? "N/A")")
            print("Genres: \(movieDetail.genres?.map { $0.name ?? "" }.joined(separator: ", ") ?? "N/A")")
            print("Runtime: \(movieDetail.runtime ?? 0) minutes")
        } catch {
            print("Error fetching movie detail:", error)
        }
    }

}

extension MoviesScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMovieMode {
            searchResults.count
        } else {
            popularMoviesArray.count
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if searchMovieMode {
            var results = searchResults[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell else
            {
                return UICollectionViewCell()
            }
            cell.contentView.backgroundColor = .blue
            cell.movieTitleLabel.text = results.title
            cell.releaseLabel.text = results.firstAirDate
            if let url = URL(string: baseImgUrl + (results.posterPath ?? "")) {
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        cell.movieImage.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell else
            {
                return UICollectionViewCell()
            }
            let movie = popularMoviesArray[indexPath.row]

            if let url = URL(string: baseImgUrl + (movie.posterPath ?? "")) {
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        cell.movieImage.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
            cell.contentView.backgroundColor = .systemBackground
            cell.movieTitleLabel.text = movie.title
            cell.releaseLabel.text = formatDate(dateString: movie.releaseDate)
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        var results = searchResults[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell else
        { return }
        Task {
            await fetchMovieDetail(id: results.id ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        // Prepare the layout of setting 2 cells in every row.
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = layout.minimumInteritemSpacing
        let sectionInsets = layout.sectionInset.left + layout.sectionInset.right
        let totalSpacing = spacing + sectionInsets
        

        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: width * 1.5)
    }

}

// MARK: - UITextFieldDelegate
extension MoviesScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let current = textField.text as NSString? {
            let newText = current.replacingCharacters(in: range, with: string)
            newText.count == 0 ? (searchMovieMode = false ) : (searchMovieMode = true)
            Task {
                await searchForMovies(textQuery: newText)
            }
            print(newText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let query = textField.text, !query.isEmpty {
            //performSearch(query: query)
            print(query)
        }
        return true
    }
}
