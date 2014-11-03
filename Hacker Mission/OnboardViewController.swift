//
//  OnboardViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/2/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {
    
  @IBOutlet weak var proceedButto: UIButton!
  @IBOutlet weak var missionTitleWrapper: UIView!
  @IBOutlet weak var missionTitle: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageTwo: UIView!
  @IBOutlet weak var pageOne: UIView!
  @IBOutlet weak var pageThree: UIView!
  @IBOutlet weak var pageFour: UIView!
  @IBOutlet weak var backgroundImage: UIImageView!
  var startingFrame : CGRect!
  var startingTitleX : CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.delegate = self
    let screenSize = UIApplication.sharedApplication().windows.first!.size
    println(screenSize)
    let screenHeight = screenSize.height
    let screenWidth = screenSize.width
    startingFrame = backgroundImage.frame
    startingTitleX = missionTitleWrapper.frame.origin.x
    animateTitle(true)
    println(missionTitleWrapper.center.x)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//    
//    let lastPageConstraints = pageFour.constraints()
//    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//    let characterCreationVC = storyboard.instantiateViewControllerWithIdentifier("CHARCREATE_VC") as CharacterCreationViewController
//    
//    self.addChildViewController(characterCreationVC)
//    self.scrollView.addSubview(characterCreationVC.view)
//    characterCreationVC.view.frame = pageFour.frame
//    pageFour.removeFromSuperview()
//    characterCreationVC.view.addConstraints(lastPageConstraints)
//    
//  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let frameSize = backgroundImage.frame.size
    let frameX = startingFrame.origin.x
    let frameY = startingFrame.origin.y
    let offsetX = scrollView.contentOffset.x / 5
    backgroundImage.frame = CGRect(origin: CGPoint(x: frameX - offsetX, y: frameY), size: frameSize)
    
//    missionTitleWrapper.frame.origin.x = startingTitleX - offsetX
//    println(missionTitleWrapper.center.x)
    
  }
  @IBAction func proceedButtonPressed(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let launchVC = storyboard.instantiateViewControllerWithIdentifier("LAUNCHVIEW_VC") as LaunchViewController
    self.presentViewController(launchVC, animated: true, completion: nil)
  }
  
  func animateTitle(isAtTop: Bool) {
    if isAtTop{
      UIView.animateWithDuration(2.0,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.missionTitle.center.y = self.missionTitle.center.y + 20
        },
        completion: { (success) -> Void in
          self.animateTitle(false)
      })
    } else {
      UIView.animateWithDuration(2.0,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.missionTitle.center.y = self.missionTitle.center.y - 20
        },
        completion: { (success) -> Void in
          self.animateTitle(true)
      })
    }
    
  }

}
