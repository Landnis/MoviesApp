//
//  MoviesScreenViewController.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class MoviesScreenViewController: UIViewController {
    let apiKey = "6b2e856adafcc7be98bdf0d8b076851c"
    var url: URL? {
           URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")
       }
    @IBOutlet var movieScreenView: MoviesScreenView! {
        didSet {
            movieScreenView.backgroundColor = .white
        }
    }
    var popularMoviesArray = [PopularMovies]()
    override func viewDidLoad() {
        super.viewDidLoad()
        movieScreenView.collectionView.delegate = self
        movieScreenView.collectionView.dataSource = self
        Task {
            await getPopularMovies()
        }
    }
    
    func getPopularMovies() async {
        guard let url = url else { return }
        
        do {
            let movieResponse: MovieResponse = try await NetworkManager.shared.request(url: url)
            print(movieResponse)
            popularMoviesArray = movieResponse.results
            movieScreenView.collectionView.reloadData()
        } catch {
            print("Error fetching movies:", error)
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

}

extension MoviesScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        popularMoviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell else
        {
            return UICollectionViewCell()
        }
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let movie = popularMoviesArray[indexPath.row]

        if let url = URL(string: baseUrl + (movie.posterPath ?? "")) {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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
