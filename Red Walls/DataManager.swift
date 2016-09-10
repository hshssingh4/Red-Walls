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
    
    func isFavorite(wp: Wallpaper) -> Bool {
        for favorite in favorites {
            if favorite.id == wp.id {
                return true
            }
        }
        return false
    }
    
    func indexOfFavorite(wp: Wallpaper) -> Int {
        for index in 0...(favorites.count-1) {
            if favorites[index].id == wp.id {
                return index
            }
        }
        return -1
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
