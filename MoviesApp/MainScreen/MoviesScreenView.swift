//
//  MoviesScreenView.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class MoviesScreenView: UIView {

    @IBOutlet weak var topView: MoviesScreenView! {
        didSet {
            topView.backgroundColor = .systemFill
            topView.layer.cornerRadius = 21.0
            topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            topView.clipsToBounds = true
            topView.layer.masksToBounds = false
            topView.layer.shadowColor = UIColor.black.cgColor
            topView.layer.shadowOpacity = 0.3
            topView.layer.shadowOffset = CGSize(width: 0, height: 5)
            topView.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.backgroundColor = .white
            textField.keyboardType = .default
            textField.placeholder = "Search..."
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.backgroundColor = .clear
            collectionView.isScrollEnabled = true
            
            let popularMovieNibname = UINib(nibName: "PopularMoviesCell", bundle: nil)
            collectionView.register(popularMovieNibname, forCellWithReuseIdentifier: "PopularMoviesCell")
        }
    }

}
