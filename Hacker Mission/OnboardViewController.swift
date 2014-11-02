//
//  OnboardViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/2/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {
    
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageTwo: UIView!
  @IBOutlet weak var pageOne: UIView!
  @IBOutlet weak var pageThree: UIView!
  @IBOutlet weak var pageFour: UIView!
  @IBOutlet weak var backgroundImage: UIImageView!
  var startingFrame : CGRect!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.delegate = self
    let screenSize = UIApplication.sharedApplication().windows.first!.size
    println(screenSize)
    let screenHeight = screenSize.height
    let screenWidth = screenSize.width
    
    startingFrame = backgroundImage.frame
    
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let frameSize = backgroundImage.frame.size
    let frameX = startingFrame.origin.x
    let frameY = startingFrame.origin.y
    let offsetX = scrollView.contentOffset.x / 5
    backgroundImage.frame = CGRect(origin: CGPoint(x: frameX - offsetX, y: frameY), size: frameSize)
  }

}
