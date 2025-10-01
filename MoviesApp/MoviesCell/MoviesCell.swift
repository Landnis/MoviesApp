//
//  MoviesCell.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class MoviesCell: UITableViewCell {

    @IBOutlet weak var releaseTitleLabel: UILabel! {
        didSet {
            releaseTitleLabel.textColor = .black
            releaseTitleLabel.font = UIFont.systemFont(ofSize: 15)
            releaseTitleLabel.numberOfLines = 0
            releaseTitleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var movieImg: UIImageView!{
        didSet {
            movieImg.backgroundColor = .clear
            movieImg.layer.cornerRadius = 51.0
            movieImg.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
            titleLabel.font = UIFont.systemFont(ofSize: 17)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
