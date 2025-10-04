//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 2/10/25.
//

import UIKit

class MovieDetailsView: UIView {

    @IBOutlet weak var tabBarView: UIView! {
        didSet {
            tabBarView.backgroundColor = .lightGray
        }
    }
    
    @IBOutlet weak var backbutton: UIButton! {
        didSet {
            backbutton.setImage(UIImage(named: "back_img")?.withRenderingMode(.alwaysTemplate), for: .normal)
            backbutton.tintColor = .white
            backbutton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.isScrollEnabled = true
            
            let movieDetailsCellNibname = UINib(nibName: "MovieDetailsCell", bundle: nil)
            collectionView.register(movieDetailsCellNibname, forCellWithReuseIdentifier: "MovieDetailsCell")
            
            let movieCastCellCellNibname = UINib(nibName: "MovieCastCell", bundle: nil)
            collectionView.register(movieCastCellCellNibname, forCellWithReuseIdentifier: "MovieCastCell")
            
        }
    }
    
    @IBOutlet weak var logoImg: UIImageView! {
        didSet {
            logoImg.image = UIImage(named: "transparent_movieImg")
        }
    }
    
}
