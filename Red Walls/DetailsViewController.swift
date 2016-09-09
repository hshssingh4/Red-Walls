//
//  DetailsViewController.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/9/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var sourceImageView: UIImageView!
    
    var wallpaper: Wallpaper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sourceImageView.clipsToBounds = true
        sourceImageView.setImageWithURL(wallpaper.sourceImageURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
