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

class WallpaperCell: UICollectionViewCell {
    
    @IBOutlet var wallpaperImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var labelsView: UIView!
    
    var wallpaper: Wallpaper! {
        didSet {
            usernameLabel.text = wallpaper.username
            wallpaperImageView.clipsToBounds = true
            /*if let sourceImageURL = wallpaper.sourceImageURL {
                wallpaperImageView.setImageWithURL(sourceImageURL)
            }
            else {
                wallpaperImageView.image = UIImage(named: "ImageNotAvailable")
            }*/
    
            
            let request = NSURLRequest(URL: wallpaper.highResolutionImageURL!)
            wallpaperImageView.setImageWithURLRequest(request, placeholderImage: nil, success: {(request:NSURLRequest!,response:NSHTTPURLResponse?, image:UIImage!) -> Void in
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
}
