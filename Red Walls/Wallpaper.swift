//
//  Wallpaper.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

// This class represents a single wallpaper object
class Wallpaper: NSObject {
    var username: String
    
    init(dataDict: NSDictionary) {
        username = dataDict["author"] as! String
    }
}
