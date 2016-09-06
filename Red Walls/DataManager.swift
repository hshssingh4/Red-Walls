//
//  DataManager.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

// This class manages the data component for the app
class DataManager: NSObject {
    var wallpapers: [Wallpaper] = []
    
    /**
     This method add a wallpaper to the wallpapers array.
     */
    func addWallpaper(wallpaper: Wallpaper) {
        wallpapers.append(wallpaper)
    }
}
