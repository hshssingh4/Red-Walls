//
//  WallpaperCell.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class WallpaperCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    
    
    var wallpaper: Wallpaper! {
        didSet {
            usernameLabel.text = wallpaper.username
        }
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
