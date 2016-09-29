//
//  WallpaperCell.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/8/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

// This class represents the prototype UICollectionViewCell in the storyboard.
class WallpaperCell: UICollectionViewCell {
    
    @IBOutlet var wallpaperImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var labelsView: UIView!
    
    // Init the wallpaper cell elements with values from the wallpaper object.
    var wallpaper: Wallpaper! {
        didSet {
            usernameLabel.text = wallpaper.username
            wallpaperImageView.clipsToBounds = true
            
            // Requesting for the image from the Web.
            let request = URLRequest(url: wallpaper.highResolutionImageURL as URL)
            wallpaperImageView.setImageWith(request, placeholderImage: nil, success: {(request:URLRequest!,response:HTTPURLResponse?, image:UIImage!) -> Void in
                if response != nil {
                    self.wallpaperImageView.image = image
                }
                else {
                    self.wallpaperImageView.image = image
                }
            }, failure: nil)
            
            titleLabel.text = wallpaper.title
        }
    }
    
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
    }
}
