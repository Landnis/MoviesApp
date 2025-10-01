//
//  PopularMoviesCell.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 1/10/25.
//

import UIKit

class PopularMoviesCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundContainerView: UIView! {
        didSet {
            backgroundContainerView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var movieImage: UIImageView! {
        didSet {
            movieImage.backgroundColor = .clear
            movieImage.layer.cornerRadius = 51.0
            movieImage.clipsToBounds = true
            movieImage.layer.masksToBounds = false
            movieImage.layer.shadowColor = UIColor.black.cgColor
            movieImage.layer.shadowOpacity = 0.5
            movieImage.layer.shadowOffset = CGSize(width: 0, height: 5)
            movieImage.layer.shadowRadius = 15
        }
    }
    
    @IBOutlet weak var movieTitleLabel: UILabel! {
        didSet {
            movieTitleLabel.textColor = .black
            movieTitleLabel.font = UIFont.systemFont(ofSize: 17)
            movieTitleLabel.numberOfLines = 0
            movieTitleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var releaseLabel: UILabel! {
        didSet {
            releaseLabel.textColor = .black
            releaseLabel.font = UIFont.systemFont(ofSize: 15)
            releaseLabel.numberOfLines = 0
            releaseLabel.textAlignment = .center
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

}
