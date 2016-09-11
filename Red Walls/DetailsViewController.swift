//
//  DetailsViewController.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/9/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

// Class that displays the wallpaper image in full screen mode and allows users to download it.
class DetailsViewController: UIViewController {

    
    @IBOutlet var sourceImageView: UIImageView!
    @IBOutlet var topView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var numLikesLabel: UILabel!
    @IBOutlet var numCommentsLabel: UILabel!
    @IBOutlet var numScoreLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    
    var wallpaper: Wallpaper! // The particular wallpaper object for this class.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initInfoView() // View on the bottom.
        initStatusBarBackgroundView() // View behind the status bar that also includes close and download buttons.
        loadImage() // Load the image from the server.
        sourceImageView.clipsToBounds = true
        addParallaxEffect() // Add a parallax effect to make it more engaging.
    }
    
    /**
     This is the view on the bottom that contains labels and everything else theoretically. In reality, those labels are not directly inside it.
    */
    func initInfoView() {
        titleLabel.text = wallpaper.title
        numLikesLabel.text = "\(wallpaper.numLikes)"
        numCommentsLabel.text = "\(wallpaper.numComments)"
        numScoreLabel.text = "\(wallpaper.score)"
    }
    
    /**
     This method creates a nice parallax effect to create a user immersive display.s
    */
    func addParallaxEffect() {
        let rotationValue = 50
        
        let horizontalRotation = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        let verticalRotation = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        horizontalRotation.minimumRelativeValue = -rotationValue
        horizontalRotation.maximumRelativeValue = rotationValue
        verticalRotation.minimumRelativeValue = -rotationValue
        verticalRotation.maximumRelativeValue = rotationValue
        
        let motionEffectsArray = UIMotionEffectGroup()
        motionEffectsArray.motionEffects = [horizontalRotation, verticalRotation]
        sourceImageView.addMotionEffect(motionEffectsArray)
    }
    
    /**
     This is the tap gesture to hide and show the views on the screen. It lets user to get a sense of how the image would appear on screen without any other views.
    */
    @IBAction func onContentViewTapGesture(sender: UITapGestureRecognizer) {
        if topView.hidden == false {
            UIApplication.sharedApplication().statusBarHidden = true
            scrollView.scrollEnabled = false
            UIView.transitionWithView(topView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {() -> Void in
                self.topView.hidden = true
                self.closeButton.hidden = true
                self.saveButton.hidden = true
            }, completion: nil)
            UIView.transitionWithView(infoView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.infoView.hidden = true
                self.titleLabel.hidden = true
                self.numLikesLabel.hidden = true
                self.likesLabel.hidden = true
                self.numCommentsLabel.hidden = true
                self.commentsLabel.hidden = true
                self.numScoreLabel.hidden = true
                self.scoreLabel.hidden = true
            }, completion: nil)
        }
        else {
            UIApplication.sharedApplication().statusBarHidden = false
            scrollView.scrollEnabled = true
            UIView.transitionWithView(topView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {() -> Void in
                self.topView.hidden = false
                }, completion: nil)
            UIView.animateWithDuration(0.4, animations: { 
                self.closeButton.hidden = false
                self.saveButton.hidden = false
            })
            UIView.transitionWithView(infoView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.infoView.hidden = false
                }, completion: nil)
            UIView.animateWithDuration(0.4, animations: { 
                self.titleLabel.hidden = false
                self.numLikesLabel.hidden = false
                self.likesLabel.hidden = false
                self.numCommentsLabel.hidden = false
                self.commentsLabel.hidden = false
                self.numScoreLabel.hidden = false
                self.scoreLabel.hidden = false
            })
        }
    }
    
    /**
     Sets the content size for the scroll view.
    */
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Dismisses the view controller.
    */
    @IBAction func onCloseButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Saves this wallpaper to the photos album.
    */
    @IBAction func onSaveButtonPressed(sender: UIButton) {
        SVProgressHUD.show()
        UIImageWriteToSavedPhotosAlbum(sourceImageView.image!, self, #selector(DetailsViewController.saveImage), nil)
    }
    
    func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            SVProgressHUD.dismiss()
            let alertController = UIAlertController(title: "Saved", message: "Saved Succesfully", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            SVProgressHUD.dismiss()
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
    
    /**
     Private method to load the image and place it in the source image view.
    */
    private func loadImage() {
        let smallImageUrl = wallpaper.highResolutionImageURL
        let largeImageUrl = wallpaper.sourceImageURL
        
        let smallImageRequest = NSURLRequest(URL: smallImageUrl)
        let largeImageRequest = NSURLRequest(URL: largeImageUrl)
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
