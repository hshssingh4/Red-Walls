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
    var highResolutionImageURL: NSURL?
    var title: String
    var id: String
    
    
    init(dataDict: NSDictionary) {
        username = dataDict["author"] as! String
        
        var imagesDict = dataDict["preview"]?["images"]
        if imagesDict != nil {
            imagesDict = (imagesDict as! NSArray)[0] as! NSDictionary
        }
        if imagesDict != nil {
            let resolutionsArray = (imagesDict!!["resolutions"] as! NSArray)
            let urlDict = resolutionsArray[resolutionsArray.count - 1] as! NSDictionary
            let tempString = urlDict["url"] as! String
            let urlString = tempString.stringByReplacingOccurrencesOfString("amp;", withString: "")
            highResolutionImageURL = NSURL(string: urlString)
            
            let sourceDict = imagesDict!!["source"] as! NSDictionary
            let sourceUrlString = sourceDict["url"] as! String
            sourceImageURL = NSURL(string: sourceUrlString)
            
        }
        
        title = dataDict["title"] as! String
        id = dataDict["id"] as! String
    }
}
