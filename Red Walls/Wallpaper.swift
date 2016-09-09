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
    var sourceImageURL: NSURL?
    var title: String
    var id: String
    
    
    init(dataDict: NSDictionary) {
        username = dataDict["author"] as! String
        var imagesDict = dataDict["preview"]?["images"]
        if imagesDict != nil {
            imagesDict = (imagesDict as! NSArray)[0] as! NSDictionary
        }
        if imagesDict != nil {
            sourceImageURL = NSURL(string: (imagesDict!!["source"]!!["url"] as! String))
        }
        
        title = dataDict["title"] as! String
        id = dataDict["id"] as! String
    }
}
