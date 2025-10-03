//
//  MovieCastCell.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 2/10/25.
//

import UIKit

class MovieCastCell: UICollectionViewCell {
    var baseImgUrl = "https://image.tmdb.org/t/p/w500"
    var creditsArray = [Cast]()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.isScrollEnabled = true
            
            let movieDetailsCellNibname = UINib(nibName: "MovieDetailsCell", bundle: nil)
            collectionView.register(movieDetailsCellNibname, forCellWithReuseIdentifier: "MovieDetailsCell")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
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

extension MovieCastCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        creditsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailsCell", for: indexPath) as? MovieDetailsCell else
        {
            return UICollectionViewCell()
        }
        let cast = creditsArray[indexPath.row]
        Task {
            if let image = await fetchImage(imagePath: cast.profilePath ?? "N/A") {
                cell.movieImg.image = image
            }
        }
        cell.titleLabel.text = cast.name
        cell.genreLabel.isHidden = true
        cell.summaryLabel.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 1.5)
    }

}
