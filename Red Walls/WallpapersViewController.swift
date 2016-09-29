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
class WallpapersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CAAnimationDelegate {

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
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.object(forKey: "favorites") as? Data {
            dataManager.favorites = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Wallpaper]
        }
    }
    
    /**
     Before the view disppears, make sure the favorites are stored in NSUserDefaults so that they can be retrieved later.
    */
    override func viewWillDisappear(_ animated: Bool) {
        let data = NSKeyedArchiver.archivedData(withRootObject: dataManager.favorites)
        UserDefaults.standard.set(data, forKey: "favorites")
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("favorites")
    }
    
    /**
     This method loads the wallpaper by first requesting for the data and then by populating the data manager.
    */
    func loadWallpapers() {
        let url = URL(string: "https://www.reddit.com/r/wallpapers.json")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        // Deserialize the Json data
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                with: data, options:[]) as? NSDictionary {
                    let wallpapersDict = (responseDictionary["data"] as! NSDictionary) ["children"] as! [NSDictionary]
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
                let alertController = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    self.loadWallpapers()
                }))
                self.present(alertController, animated: true, completion: nil)
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
        refreshControl.addTarget(self, action: #selector(WallpapersViewController.onRefresh), for: UIControlEvents.valueChanged)
        wallpapersCollectionView.insertSubview(refreshControl, at: 0)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.wallpapers.count
    }
    
    /**
     Sets data according to the wallpapers in the array and populates the collection view.
    */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wallpapersCollectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell

        // If block for the case where the user refreshes and pulls simultaneously
        if ((indexPath as NSIndexPath).row <= dataManager.wallpapers.count - 1) {
            cell.wallpaper = dataManager.wallpapers[(indexPath as NSIndexPath).row]
            
            if dataManager.isFavorite(dataManager.wallpapers[(indexPath as NSIndexPath).row]) {
                cell.favoriteButton.setImage(UIImage(named: "FavoriteIcon"), for: UIControlState())
            }
            else {
                cell.favoriteButton.setImage(UIImage(named: "UnfavoriteIcon"), for: UIControlState())
            }
        }
        
        return cell
    }
    
    /**
     Changes the size of the collection view according to different screen sizes.
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let height = CGFloat(259)
        let width = UIScreen.main.bounds.width - 10
        return CGSize(width: width, height: height)
    }
    
    /**
     This just highlights and unhighlights the cell when user selects and releases a cell to notify them of the touch using an animation.
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = ColorPalette.LightGrayColor
        UIView.animate(withDuration: 0.3, animations: {
            cell?.backgroundColor = ColorPalette.CellColor
        })
    }
    
    /**
     This just highlights the cell when user selects it to notify them of the touch.
    */
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = ColorPalette.LightGrayColor
    }
    
    /**
     This method is used for unhilighting the collection view cell's background color.
    */
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = ColorPalette.CellColor
    }
    
    /**
     Handler for the click on favorite button.
     1. If user decides to favorite a wallpaper. that wallpaper is immediately added to the favorites array.
     2. However, if a user decides to unfavorite an already favorites wallpaper, they are asked to verify their decision.
    */
    @IBAction func onFavoriteButtonPressed(_ sender: UIButton) {
        let cell = sender.superview?.superview as! WallpaperCell
        let indexPath = self.wallpapersCollectionView.indexPath(for: cell)
        let wallpaper = dataManager.wallpapers[((indexPath as NSIndexPath?)?.row)!]
        
        if dataManager.isFavorite(wallpaper) {
            let alertController = UIAlertController(title: "Are you sure you want to unfavorite?", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Unfavorite", style: .destructive, handler: { (action) in
                let index = self.dataManager.indexOfFavorite(wallpaper)
                self.dataManager.removeFavorite(index)
                sender.setImage(UIImage(named: "UnavoriteIcon"), for: UIControlState())
                let transition = CATransition()
                transition.delegate = self
                transition.duration = 0.2
                transition.type = kCATransitionFade
                sender.imageView?.layer.add(transition, forKey: kCATransition)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            dataManager.addFavorite(wallpaper)
            
            sender.setImage(UIImage(named: "FavoriteIcon"), for: UIControlState())
            let transition = CATransition()
            transition.delegate = self
            transition.duration = 0.2
            transition.type = kCATransitionFade
            sender.imageView?.layer.add(transition, forKey: kCATransition)
        }
    }
    
    /**
     This method is used to reload the collection view data after user decudes to favorite or unfavorite a wallpaper.
     It is required to make sure the state of button used to favorite/unfavorite is visible on screen.
    */
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.wallpapersCollectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UICollectionViewCell {
            let indexPath = wallpapersCollectionView.indexPath(for: cell)
            let wallpaper = dataManager.wallpapers[((indexPath as NSIndexPath?)?.row)!]
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.wallpaper = wallpaper
        }
    }
    

}
