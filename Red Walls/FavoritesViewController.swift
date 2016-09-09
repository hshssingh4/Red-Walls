//
//  FavoritesViewController.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/8/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var dataManager: DataManager?

    @IBOutlet var favoritesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = ColorPalette.BrandColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorPalette.WhiteColor]
    }
    
    override func viewWillAppear(animated: Bool) {
        let wallpapersViewController = (tabBarController?.viewControllers![0] as! UINavigationController).topViewController as! WallpapersViewController
        dataManager = wallpapersViewController.dataManager
        
        if (dataManager?.favorites.count == 0) {
            favoritesCollectionView.hidden = true
        }
        else {
            favoritesCollectionView.hidden = false
        }
        
        self.favoritesCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    /*****  Collection View Methods  *****/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager!.favorites.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCellWithReuseIdentifier("FavoriteCell", forIndexPath: indexPath) as! FavoriteCell
        
        cell.wallpaper = dataManager?.favorites[indexPath.row]
        
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
