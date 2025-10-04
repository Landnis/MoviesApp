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
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        movieScreenView.collectionView.delegate = self
        movieScreenView.collectionView.dataSource = self
        movieScreenView.textField.delegate = self
        setupRefreshControl()
        Task {
            await getPopularMovies()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    private func presentMovieScreen(movieId: Int) {
        let movieDeatilsScreenVC = MovieDetaisViewViewController()
        movieDeatilsScreenVC.movieId = movieId
        self.navigationController?.pushViewController(movieDeatilsScreenVC, animated: true)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        movieScreenView.collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionView() {
        Task {
            await getPopularMovies()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
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
            print("Found \(filteredResults) results")
            searchResults = filteredResults
            movieScreenView.collectionView.reloadData()
        } catch {
            print("Error searching movies:", error)
        }
    }
    
    private func fetchImage(imagePath: String) async -> UIImage? {
        guard let url = URL(string: baseImgUrl + imagePath) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image:", error)
            return nil
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
            cell.contentView.backgroundColor = .systemBackground
            cell.movieTitleLabel.text = results.title
            cell.releaseLabel.isHidden = true
            Task {
                if let image = await fetchImage(imagePath: results.posterPath ?? "") {
                    cell.movieImage.image = image
                } else {
                    cell.movieImage.image = UIImage(named: "userDefaultImg")
                }
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell else
            {
                return UICollectionViewCell()
            }
            let movie = popularMoviesArray[indexPath.row]
            cell.releaseLabel.isHidden = false
            Task {
                if let image = await fetchImage(imagePath: movie.posterPath ?? "") {
                    cell.movieImage.image = image
                } else {
                    cell.movieImage.image = UIImage(named: "userDefaultImg")
                }
            }
            cell.contentView.backgroundColor = .systemBackground
            cell.movieTitleLabel.text = movie.title
            cell.releaseLabel.text = formatDate(dateString: movie.releaseDate)
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if searchMovieMode {
            let results = searchResults[indexPath.row]
            presentMovieScreen(movieId: results.id ?? 0)
        } else {
            let results = popularMoviesArray[indexPath.row]
            presentMovieScreen(movieId: results.id)
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
