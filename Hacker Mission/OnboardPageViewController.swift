//
//  OnboardPageViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/2/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import QuartzCore

class OnboardPageViewController: UIViewController {

  @IBOutlet weak var paragraph1: UILabel!
  @IBOutlet weak var paragraph2: UILabel!
  @IBOutlet weak var paragraph3: UILabel!
  @IBOutlet weak var paragraph4: UILabel!
  @IBOutlet weak var paragraph5: UILabel!
  @IBOutlet weak var paragraph6: UILabel!
  
  
  var p1 : String?
  var p2 : String?
  var p3 : String?
  var p4 : String?
  var p5 : String?
  var p6 : String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.clearColor()
    if let text = p1 {
      paragraph1.text = text
    }
    if let text = p2 {
      paragraph2.text = text
    }
    if let text = p3 {
      paragraph3.text = text
    }
    if let text = p4 {
      paragraph4.text = text
    }
    if let text = p5 {
      paragraph5.text = text
    }
    if let text = p6 {
      paragraph6.text = text
      if text == "Trust no one." {
        paragraph6.textColor = UIColor.redColor()
//        self.pulseColor(paragraph6.layer)
      }
    }
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "startPulsing:", name: UIApplicationDidBecomeActiveNotification, object: nil)

  }

  override func viewDidAppear(animated: Bool) {
    if let text = p6 {
      paragraph6.text = text
      if text == "Trust no one." {
        paragraph6.textColor = UIColor.redColor()
        self.pulseColor(paragraph6.layer)
      }
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func pulseColor(layer: CALayer) {
    let theAnimation = CABasicAnimation(keyPath: "opacity")
    theAnimation.delegate = self

    println("here in core animation")
    theAnimation.repeatCount = 10000.0
    theAnimation.autoreverses = true
    theAnimation.fromValue = 0.5
    theAnimation.toValue = 1.0
      theAnimation.duration = 1.0
      layer.addAnimation(theAnimation, forKey: "opacity")
      layer.opacity = 1.0
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func startPulsing(notification : NSNotification) {
    if let text = p6 {
      paragraph6.text = text
      if text == "Trust no one." {
        paragraph6.textColor = UIColor.redColor()
        self.pulseColor(paragraph6.layer)
      }
    }
  }


}
