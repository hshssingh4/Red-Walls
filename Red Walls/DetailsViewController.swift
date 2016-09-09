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
    @IBOutlet var topView: UIView!
    
    var wallpaper: Wallpaper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStatusBarBackgroundView()
        loadImage()
        sourceImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSaveButtonPressed(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(sourceImageView.image!, self, #selector(DetailsViewController.saveImage), nil)
    }
    
    func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let alertController = UIAlertController(title: "Saved", message: "Image saved succesfully.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    

    /**
     This method adds a view behind status bar.
     */
    private func initStatusBarBackgroundView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = topView.bounds
        gradientLayer.colors = ColorPalette.GradientColors.BlackClear
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        topView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    private func loadImage() {
        if wallpaper.highResolutionImageURL != nil {
            let smallImageUrl = wallpaper.highResolutionImageURL
            let largeImageUrl = wallpaper.sourceImageURL
            
            let smallImageRequest = NSURLRequest(URL: smallImageUrl!)
            let largeImageRequest = NSURLRequest(URL: largeImageUrl!)
            
            self.sourceImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: {(smallImageRequest:NSURLRequest!,smallImageResponse:NSHTTPURLResponse?, smallImage:UIImage!) -> Void in
                    self.sourceImageView.image = smallImage
                    
                    UIView.animateWithDuration(
                        0.5, animations: {}, completion: { (success) -> Void in
                            
                            self.sourceImageView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.sourceImageView.image = largeImage
                                },
                                failure: nil)
                    })
                }, failure: nil)
        }
        else {
            print("yes")
            sourceImageView.image = UIImage(named: "ImageNotAvailable")
        }
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
