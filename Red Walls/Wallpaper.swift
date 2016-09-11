//
//  Wallpaper.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

// This class represents a single wallpaper object
class Wallpaper: NSObject, NSCoding {
    var username: String
    var sourceImageURL: NSURL
    var highResolutionImageURL: NSURL
    var title: String
    var id: String
    var numLikes: Int
    var numComments: Int
    var score: Int
    
    /**
     Constructor for the wallpaper object. Initializes values based on the 
     value in the NSDictionary obtained from the Reddit JSON file.
    */
    init(dataDict: NSDictionary) {
        username = dataDict["author"] as! String
        
        // Set to placeholder images first. Then make the call to fetch the actual image.
        highResolutionImageURL = NSURL(string: "http://i.imgur.com/XLzAkpK.jpg")!
        sourceImageURL = NSURL(string: "http://i.imgur.com/XLzAkpK.jpg")!
        
        var imagesDict = dataDict["preview"]?["images"]
        if imagesDict != nil {
            imagesDict = (imagesDict as! NSArray)[0] as! NSDictionary
        }
        
        // Fetching the actual image.
        if imagesDict != nil {
            let resolutionsArray = (imagesDict!!["resolutions"] as! NSArray)
            if resolutionsArray.count > 0 {
                let urlDict = resolutionsArray[resolutionsArray.count - 1] as! NSDictionary
                let tempString = urlDict["url"] as! String
                let urlString = tempString.stringByReplacingOccurrencesOfString("amp;", withString: "")
                highResolutionImageURL = NSURL(string: urlString)!
                
                let sourceDict = imagesDict!!["source"] as! NSDictionary
                let sourceUrlString = sourceDict["url"] as! String
                sourceImageURL = NSURL(string: sourceUrlString)!
            }
        }
        
        title = dataDict["title"] as! String
        id = dataDict["id"] as! String
        numLikes = dataDict["ups"] as! Int
        numComments = dataDict["num_comments"] as! Int
        score = dataDict["score"] as! Int
    }
    
    // Using NSCoding to store the dict and to load it back in
    
    // Decodes the values
    required init(coder decoder: NSCoder) {
        username = decoder.decodeObjectForKey("author") as! String
        sourceImageURL = decoder.decodeObjectForKey("sourceURL") as! NSURL
        highResolutionImageURL = decoder.decodeObjectForKey("resolutionURL") as! NSURL
        title = decoder.decodeObjectForKey("title") as! String
        id = decoder.decodeObjectForKey("id") as! String
        numLikes = decoder.decodeIntegerForKey("ups")
        numComments = decoder.decodeIntegerForKey("num_comments")
        score = decoder.decodeIntegerForKey("score")
    }
    
    // Encodes the values
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.username, forKey: "author")
        coder.encodeObject(self.sourceImageURL, forKey: "sourceURL")
        coder.encodeObject(self.highResolutionImageURL, forKey: "resolutionURL")
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeInteger(self.numLikes, forKey: "ups")
        coder.encodeInteger(self.numComments, forKey: "num_comments")
        coder.encodeInteger(self.score, forKey: "score")
    }
}
