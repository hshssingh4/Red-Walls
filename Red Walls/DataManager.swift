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
    var favorites: [Wallpaper] = []
    
    /**
     This method add a wallpaper to the wallpapers array.
     */
    func addWallpaper(wallpaper: Wallpaper) {
        wallpapers.append(wallpaper)
    }
    
    /**
     This method add a wallpaper to the favories array.
     */
    func addFavorite(wallpaper: Wallpaper) {
        favorites.append(wallpaper)
    }
    
    /**
     This method removes a wallpaper from the favories array.
     */
    func removeFavorite(index: Int) {
        favorites.removeAtIndex(index)
    }
    
    func contains(wp: Wallpaper) -> Bool {
        for wallpaper in wallpapers {
            if wallpaper.id == wp.id {
                return true
            }
        }
        return false
    }
}
