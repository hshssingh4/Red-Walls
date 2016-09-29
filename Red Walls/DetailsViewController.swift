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
        
        let horizontalRotation = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        let verticalRotation = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
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
    @IBAction func onContentViewTapGesture(_ sender: UITapGestureRecognizer) {
        if topView.isHidden == false {
            UIApplication.shared.isStatusBarHidden = true
            scrollView.isScrollEnabled = false
            UIView.transition(with: topView, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                self.topView.isHidden = true
                self.closeButton.isHidden = true
                self.saveButton.isHidden = true
            }, completion: nil)
            UIView.transition(with: infoView, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.infoView.isHidden = true
                self.titleLabel.isHidden = true
                self.numLikesLabel.isHidden = true
                self.likesLabel.isHidden = true
                self.numCommentsLabel.isHidden = true
                self.commentsLabel.isHidden = true
                self.numScoreLabel.isHidden = true
                self.scoreLabel.isHidden = true
            }, completion: nil)
        }
        else {
            UIApplication.shared.isStatusBarHidden = false
            scrollView.isScrollEnabled = true
            UIView.transition(with: topView, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                self.topView.isHidden = false
                }, completion: nil)
            UIView.animate(withDuration: 0.4, animations: { 
                self.closeButton.isHidden = false
                self.saveButton.isHidden = false
            })
            UIView.transition(with: infoView, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.infoView.isHidden = false
                }, completion: nil)
            UIView.animate(withDuration: 0.4, animations: { 
                self.titleLabel.isHidden = false
                self.numLikesLabel.isHidden = false
                self.likesLabel.isHidden = false
                self.numCommentsLabel.isHidden = false
                self.commentsLabel.isHidden = false
                self.numScoreLabel.isHidden = false
                self.scoreLabel.isHidden = false
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
    @IBAction func onCloseButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     Saves this wallpaper to the photos album.
    */
    @IBAction func onSaveButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        UIImageWriteToSavedPhotosAlbum(sourceImageView.image!, self, #selector(DetailsViewController.saveImage), nil)
    }
    
    func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            SVProgressHUD.dismiss()
            let alertController = UIAlertController(title: "Saved", message: "Saved Succesfully", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            SVProgressHUD.dismiss()
            let ac = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    

    /**
     This method adds a view behind status bar.
     */
    fileprivate func initStatusBarBackgroundView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = topView.bounds
        gradientLayer.colors = ColorPalette.GradientColors.BlackClear
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        topView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /**
     Private method to load the image and place it in the source image view.
    */
    fileprivate func loadImage() {
        let smallImageUrl = wallpaper.highResolutionImageURL
        let largeImageUrl = wallpaper.sourceImageURL
        
        let smallImageRequest = URLRequest(url: smallImageUrl as URL)
        let largeImageRequest = URLRequest(url: largeImageUrl as URL)
        
        self.sourceImageView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: {(smallImageRequest:URLRequest!,smallImageResponse:HTTPURLResponse?, smallImage:UIImage!) -> Void in
                self.sourceImageView.image = smallImage
                
                UIView.animate(
                    withDuration: 0.5, animations: {}, completion: { (success) -> Void in
                        
                        self.sourceImageView.setImageWith(
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
