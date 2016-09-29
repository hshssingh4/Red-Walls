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
    var sourceImageURL: URL
    var highResolutionImageURL: URL
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
        highResolutionImageURL = URL(string: "http://i.imgur.com/XLzAkpK.jpg")!
        sourceImageURL = URL(string: "http://i.imgur.com/XLzAkpK.jpg")!
        
        let previewDict = dataDict["preview"] as? NSDictionary
        let imagesDict = previewDict?["images"] as? NSArray
        var newDict: NSDictionary = NSDictionary()
        if imagesDict != nil {
            newDict = (imagesDict)?[0] as! NSDictionary
        }
        
        // Fetching the actual image.
        if imagesDict != nil {
            let resolutionsArray = (newDict["resolutions"] as! NSArray)
            if resolutionsArray.count > 0 {
                let urlDict = resolutionsArray[resolutionsArray.count - 1] as! NSDictionary
                let tempString = urlDict["url"] as! String
                let urlString = tempString.replacingOccurrences(of: "amp;", with: "")
                highResolutionImageURL = URL(string: urlString)!
                
                let sourceDict = newDict["source"] as! NSDictionary
                let sourceUrlString = sourceDict["url"] as! String
                sourceImageURL = URL(string: sourceUrlString)!
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
        username = decoder.decodeObject(forKey: "author") as! String
        sourceImageURL = decoder.decodeObject(forKey: "sourceURL") as! URL
        highResolutionImageURL = decoder.decodeObject(forKey: "resolutionURL") as! URL
        title = decoder.decodeObject(forKey: "title") as! String
        id = decoder.decodeObject(forKey: "id") as! String
        numLikes = decoder.decodeInteger(forKey: "ups")
        numComments = decoder.decodeInteger(forKey: "num_comments")
        score = decoder.decodeInteger(forKey: "score")
    }
    
    // Encodes the values
    func encode(with coder: NSCoder) {
        coder.encode(self.username, forKey: "author")
        coder.encode(self.sourceImageURL, forKey: "sourceURL")
        coder.encode(self.highResolutionImageURL, forKey: "resolutionURL")
        coder.encode(self.title, forKey: "title")
        coder.encode(self.id, forKey: "id")
        coder.encode(self.numLikes, forKey: "ups")
        coder.encode(self.numComments, forKey: "num_comments")
        coder.encode(self.score, forKey: "score")
    }
}
