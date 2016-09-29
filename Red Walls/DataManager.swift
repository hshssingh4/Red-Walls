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
    func addWallpaper(_ wallpaper: Wallpaper) {
        wallpapers.append(wallpaper)
    }
    
    /**
     This method add a wallpaper to the favories array.
     */
    func addFavorite(_ wallpaper: Wallpaper) {
        favorites.append(wallpaper)
    }
    
    /**
     This method removes a wallpaper from the favories array.
     */
    func removeFavorite(_ index: Int) {
        favorites.remove(at: index)
    }
    
    func isFavorite(_ wp: Wallpaper) -> Bool {
        for favorite in favorites {
            if favorite.id == wp.id {
                return true
            }
        }
        return false
    }
    
    /**
     This method returns the index of the wallpaper passed as the argument in favorites array.
    */
    func indexOfFavorite(_ wp: Wallpaper) -> Int {
        for index in 0...(favorites.count-1) {
            if favorites[index].id == wp.id {
                return index
            }
        }
        return -1
    }
    
    /**
     This method checks whether or not the arg wallpaper is present in the wallpapers array.
      Returns true, if it does, false otherwise.
    */
    func contains(_ wp: Wallpaper) -> Bool {
        for wallpaper in wallpapers {
            if wallpaper.id == wp.id {
                return true
            }
        }
        return false
    }
}
