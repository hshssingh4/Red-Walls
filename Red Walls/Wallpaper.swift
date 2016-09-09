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
            let array = (imagesDict!!["resolutions"] as! NSArray)
            let urlDict = array[array.count - 1] as! NSDictionary
            let tempString = urlDict["url"] as! String
            let urlString = tempString.stringByReplacingOccurrencesOfString("amp;", withString: "")
            sourceImageURL = NSURL(string: urlString)
        }
        
        title = dataDict["title"] as! String
        id = dataDict["id"] as! String
    }
}
