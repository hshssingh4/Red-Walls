//
//  WallpapersViewController.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

// This class manages the view controller and is the root where everything is initialized
class WallpapersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var wallpapersTableView: UITableView!
    
    let dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wallpapersTableView.dataSource = self
        wallpapersTableView.delegate = self
        
        let url = NSURL(string: "https://www.reddit.com/r/wallpapers.json")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        let wallpapersDict = responseDictionary["data"]!["children"]! as! [NSDictionary]
                        for wallpaperDict in wallpapersDict {
                            let data = wallpaperDict["data"] as! NSDictionary
                            let wallpaper = Wallpaper(dataDict: data)
                            self.dataManager.addWallpaper(wallpaper)
                        }
                        self.wallpapersTableView.reloadData()
                    }
                }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*****  Table View Methods  *****/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.wallpapers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = wallpapersTableView.dequeueReusableCellWithIdentifier("WallpaperCell") as! WallpaperCell
        
        cell.wallpaper = dataManager.wallpapers[indexPath.row]
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
