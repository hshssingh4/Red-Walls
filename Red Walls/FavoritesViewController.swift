//
//  FavoritesViewController.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/8/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

// This class manages the user favorite wallpapers.
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
    
    /**
     This method populates the collection view before the view becomes visible to the user.
    */
    override func viewWillAppear(_ animated: Bool) {
        let wallpapersViewController = (tabBarController?.viewControllers![0] as! UINavigationController).topViewController as! WallpapersViewController
        dataManager = wallpapersViewController.dataManager
        
        if (dataManager?.favorites.count == 0) {
            favoritesCollectionView.isHidden = true
        }
        else {
            favoritesCollectionView.isHidden = false
        }
        
        self.favoritesCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    /*****  Collection View Methods  *****/
    
    /**
     Return favorite wallpapers count.
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager!.favorites.count
    }
    
    /**
     Populates the cell with the correct wallpapers by reusing cells.
    */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        cell.wallpaper = dataManager?.favorites[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    /**
     Returns the collection view width based on screen sizes.
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UICollectionViewCell {
            let indexPath = favoritesCollectionView.indexPath(for: cell)
            let wallpaper = dataManager?.favorites[((indexPath as NSIndexPath?)?.row)!]
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.wallpaper = wallpaper
        }
    }
    

}
