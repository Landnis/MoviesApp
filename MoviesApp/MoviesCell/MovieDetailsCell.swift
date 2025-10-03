//
//  MovieDetailsCell.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 2/10/25.
//

import UIKit

class MovieDetailsCell: UICollectionViewCell {

    @IBOutlet weak var backgroundContainerView: UIView! {
        didSet {
            backgroundContainerView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var movieImg: UIImageView! {
        didSet {
            movieImg.backgroundColor = .clear
            movieImg.layer.cornerRadius = 51.0
            movieImg.clipsToBounds = true
            movieImg.layer.masksToBounds = false
            movieImg.layer.shadowColor = UIColor.black.cgColor
            movieImg.layer.shadowOpacity = 0.5
            movieImg.layer.shadowOffset = CGSize(width: 0, height: 5)
            movieImg.layer.shadowRadius = 15
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 24)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var summaryLabel: UILabel! {
        didSet {
            summaryLabel.textColor = .black
            summaryLabel.font = UIFont.systemFont(ofSize: 15)
            summaryLabel.numberOfLines = 0
            summaryLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var genreLabel: UILabel!{
        didSet {
            genreLabel.textColor = .black
            genreLabel.font = UIFont.systemFont(ofSize: 20)
            genreLabel.numberOfLines = 0
            genreLabel.textAlignment = .center
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

}
