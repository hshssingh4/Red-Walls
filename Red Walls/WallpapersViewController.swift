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
    
    var dataManager: DataManager = DataManager()
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
    
    /** Make sure to initialize the favorites that are stored in NSUserDefaults back to the favorites array.
    */
    override func viewWillAppear(animated: Bool) {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as? NSData {
            dataManager.favorites = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Wallpaper]
        }
    }
    
    /**
     Before the view disppears, make sure the favorites are stored in NSUserDefaults so that they can be retrieved later.
    */
    override func viewWillDisappear(animated: Bool) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(dataManager.favorites)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "favorites")
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("favorites")
    }
    
    /**
     This method loads the wallpaper by first requesting for the data and then by populating the data manager.
    */
    func loadWallpapers() {
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
        
        // Deserialize the Json data
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                data, options:[]) as? NSDictionary {
                    let wallpapersDict = responseDictionary["data"]!["children"]! as! [NSDictionary]
                    for wallpaperDict in wallpapersDict {
                        let data = wallpaperDict["data"] as! NSDictionary
                        let wallpaper = Wallpaper(dataDict: data)
                        
                        if !self.dataManager.contains(wallpaper) {
                            self.dataManager.addWallpaper(wallpaper)
                        }
                    }
                    self.wallpapersCollectionView.reloadData()
                }
            }
            else {
                // Provide an error message if the user is offile and still tries to reload data.
                let alertController = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { (action) in
                    self.loadWallpapers()
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        task.resume()
    }
    
    /**
     Refresh button to allow the users to fetch any new wallpapers that they want.
    */
    func addRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = ColorPalette.BlackColor
        refreshControl.addTarget(self, action: #selector(WallpapersViewController.onRefresh), forControlEvents: UIControlEvents.ValueChanged)
        wallpapersCollectionView.insertSubview(refreshControl, atIndex: 0)
    }
    
    /**
     Handler function to reload the wallpapers and populate the collection view.
    */
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
    /**
     Return the number of wallpaper in the wallpapers array.
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.wallpapers.count
    }
    
    /**
     Sets data according to the wallpapers in the array and populates the collection view.
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = wallpapersCollectionView.dequeueReusableCellWithReuseIdentifier("WallpaperCell", forIndexPath: indexPath) as! WallpaperCell

        // If block for the case where the user refreshes and pulls simultaneously
        if (indexPath.row <= dataManager.wallpapers.count - 1) {
            cell.wallpaper = dataManager.wallpapers[indexPath.row]
            
            if dataManager.isFavorite(dataManager.wallpapers[indexPath.row]) {
                cell.favoriteButton.setImage(UIImage(named: "FavoriteIcon"), forState: UIControlState.Normal)
            }
            else {
                cell.favoriteButton.setImage(UIImage(named: "UnfavoriteIcon"), forState: UIControlState.Normal)
            }
        }
        
        return cell
    }
    
    /**
     Changes the size of the collection view according to different screen sizes.
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = CGFloat(259)
        let width = UIScreen.mainScreen().bounds.width - 10
        return CGSizeMake(width, height)
    }
    
    /**
     This just highlights and unhighlights the cell when user selects and releases a cell to notify them of the touch using an animation.
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = ColorPalette.LightGrayColor
        UIView.animateWithDuration(0.3, animations: {
            cell?.backgroundColor = ColorPalette.CellColor
        })
    }
    
    /**
     This just highlights the cell when user selects it to notify them of the touch.
    */
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = ColorPalette.LightGrayColor
    }
    
    /**
     This method is used for unhilighting the collection view cell's background color.
    */
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = ColorPalette.CellColor
    }
    
    /**
     Handler for the click on favorite button.
     1. If user decides to favorite a wallpaper. that wallpaper is immediately added to the favorites array.
     2. However, if a user decides to unfavorite an already favorites wallpaper, they are asked to verify their decision.
    */
    @IBAction func onFavoriteButtonPressed(sender: UIButton) {
        let cell = sender.superview?.superview as! WallpaperCell
        let indexPath = self.wallpapersCollectionView.indexPathForCell(cell)
        let wallpaper = dataManager.wallpapers[(indexPath?.row)!]
        
        if dataManager.isFavorite(wallpaper) {
            let alertController = UIAlertController(title: "Are you sure you want to unfavorite?", message: nil, preferredStyle: .ActionSheet)
            alertController.addAction(UIAlertAction(title: "Unfavorite", style: .Destructive, handler: { (action) in
                let index = self.dataManager.indexOfFavorite(wallpaper)
                self.dataManager.removeFavorite(index)
                sender.setImage(UIImage(named: "UnavoriteIcon"), forState: UIControlState.Normal)
                let transition = CATransition()
                transition.delegate = self
                transition.duration = 0.2
                transition.type = kCATransitionFade
                sender.imageView?.layer.addAnimation(transition, forKey: kCATransition)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            dataManager.addFavorite(wallpaper)
            
            sender.setImage(UIImage(named: "FavoriteIcon"), forState: UIControlState.Normal)
            let transition = CATransition()
            transition.delegate = self
            transition.duration = 0.2
            transition.type = kCATransitionFade
            sender.imageView?.layer.addAnimation(transition, forKey: kCATransition)
        }
    }
    
    /**
     This method is used to reload the collection view data after user decudes to favorite or unfavorite a wallpaper.
     It is required to make sure the state of button used to favorite/unfavorite is visible on screen.
    */
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.wallpapersCollectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UICollectionViewCell {
            let indexPath = wallpapersCollectionView.indexPathForCell(cell)
            let wallpaper = dataManager.wallpapers[(indexPath?.row)!]
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            
            detailsViewController.wallpaper = wallpaper
        }
    }
    

}
