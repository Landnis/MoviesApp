//
//  StrartingVew.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class StrartingVew: UIView {

    @IBOutlet weak var movieImg: UIImageView! {
        didSet {
            movieImg.image = UIImage(named: "MoviewApp")
            movieImg.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var loadingLabel: UILabel! {
        didSet {
            loadingLabel.text = "Loading..."
            loadingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            loadingLabel.textAlignment = .center
            loadingLabel.layer.shadowColor = UIColor.black.cgColor
            loadingLabel.layer.shadowOpacity = 0.5
            loadingLabel.layer.shadowRadius = 4
            loadingLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
    }

}
