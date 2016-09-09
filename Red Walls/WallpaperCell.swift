//
//  WallpaperCell.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/8/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import AFNetworking

class WallpaperCell: UICollectionViewCell {
    
    @IBOutlet var wallpaperImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var wallpaper: Wallpaper! {
        didSet {
            usernameLabel.text = wallpaper.username
            wallpaperImageView.clipsToBounds = true
            if let sourceImageURL = wallpaper.sourceImageURL {
                wallpaperImageView.setImageWithURL(sourceImageURL)
            }
            else {
                wallpaperImageView.image = UIImage(named: "ImageNotAvailable")
            }
            titleLabel.text = wallpaper.title
        }
    }
}
