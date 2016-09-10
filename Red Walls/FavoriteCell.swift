//
//  FavoriteCell.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/8/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet var wallpaperImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var labelsView: UIView!
    
    
    var wallpaper: Wallpaper! {
        didSet {
            usernameLabel.text = wallpaper.username
            wallpaperImageView.clipsToBounds = true
            wallpaperImageView.setImageWithURL(wallpaper.highResolutionImageURL)
            titleLabel.text = wallpaper.title
            
        }
    }
}
