//
//  MovieDetaisViewViewController.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class MovieDetaisViewViewController: UIViewController {
    var movieId: Int?
    var movieDetails: MovieDetail?
    var creditsArray = [Cast]()
    var baseImgUrl = "https://image.tmdb.org/t/p/w500"
    private let refreshControl = UIRefreshControl()
    @IBOutlet var movieDetailsView: MovieDetailsView! {
        didSet {
            movieDetailsView.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailsView.collectionView.delegate = self
        movieDetailsView.collectionView.dataSource = self
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await getMovieDetail(id: movieId ?? 0)
            await getCredits(id: movieId ?? 0)
        }
    }


    @IBAction func dismissBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        movieDetailsView.collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionView() {
        Task {
            await getMovieDetail(id: movieId ?? 0)
            await getCredits(id: movieId ?? 0)
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getMovieDetail(id: Int) async {
        do {
            let movieDetail: MovieDetail = try await NetworkManager.shared.request(
                target: AppRouter.movieDetail(id: id),
                decodable: MovieDetail.self
            )
            movieDetails = movieDetail
        } catch {
            print("Error fetching movie detail:", error)
        }
    }
    
    func getCredits(id: Int) async {
        do {
            let movieCredits: MovieCredits = try await NetworkManager.shared.request(
                target: AppRouter.creditsDetails(id: id),
                decodable: MovieCredits.self
            )
            creditsArray = movieCredits.cast ?? []
            movieDetailsView.collectionView.reloadData()
            
        } catch {
            print("Error fetching movie detail:", error)
        }
    }
    
    private func getImage(imagePath: String) async -> UIImage? {
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

extension MovieDetaisViewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : creditsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailsCell", for: indexPath) as? MovieDetailsCell else
            {
                return UICollectionViewCell()
            }
            Task {
                if let image = await getImage(imagePath: movieDetails?.posterPath ?? "N/A") {
                    cell.movieImg.image = image
                }
            }
            cell.genreLabel.isHidden = false
            cell.summaryLabel.isHidden = false
            cell.titleLabel.text = movieDetails?.title
            cell.genreLabel.text = movieDetails?.genres?.first?.name ?? "N/A"
            cell.summaryLabel.text = movieDetails?.overview
            return cell
           } else {
               let cast = creditsArray[indexPath.row]
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailsCell", for: indexPath) as? MovieDetailsCell else
               {
                   return UICollectionViewCell()
               }
               Task {
                   if let image = await getImage(imagePath: cast.profilePath ?? "N/A") {
                       cell.movieImg.image = image
                   }
               }
               cell.titleLabel.text = cast.name
               cell.genreLabel.isHidden = true
               cell.summaryLabel.isHidden = true
               return cell
           }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 1.5)
        } else {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
        }
    }
    
}
