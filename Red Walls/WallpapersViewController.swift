//
//  WallpapersViewController.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

// This class manages the view controller and is the root where everything is initialized
class WallpapersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var wallpapersCollectionView: UICollectionView!
    
    let dataManager: DataManager = DataManager()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wallpapersCollectionView.dataSource = self
        wallpapersCollectionView.delegate = self
        
        loadWallpapers()
        addRefreshControl()
        
        self.navigationController?.navigationBar.barTintColor = ColorPalette.BrandColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorPalette.WhiteColor]
    }
    
    func loadWallpapers() {
        SVProgressHUD.show() // Show the progress indicator
        dataManager.wallpapers.removeAll()
        
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
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                data, options:[]) as? NSDictionary {
                    let wallpapersDict = responseDictionary["data"]!["children"]! as! [NSDictionary]
                    for wallpaperDict in wallpapersDict {
                        let data = wallpaperDict["data"] as! NSDictionary
                        let wallpaper = Wallpaper(dataDict: data)
                        self.dataManager.addWallpaper(wallpaper)
                    }
                    self.wallpapersCollectionView.reloadData()
                }
            }
        })
        task.resume()
        
        SVProgressHUD.dismiss() // Hide it when done
    }
    
    func addRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.addTarget(self, action: #selector(WallpapersViewController.onRefresh), forControlEvents: UIControlEvents.ValueChanged)
        wallpapersCollectionView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func onRefresh()
    {
        loadWallpapers()
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*****  Collection View Methods  *****/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.wallpapers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = wallpapersCollectionView.dequeueReusableCellWithReuseIdentifier("WallpaperCell", forIndexPath: indexPath) as! WallpaperCell

        // If block for refresh and pulling simultaneously
        if (indexPath.row <= dataManager.wallpapers.count - 1) {
            cell.wallpaper = dataManager.wallpapers[indexPath.row]
        }
        
        return cell
    }
    
    @IBAction func onFavoriteButtonPressed(sender: UIButton) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
