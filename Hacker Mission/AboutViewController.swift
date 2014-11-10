//
//  AboutViewController.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 11/9/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  @IBOutlet weak var confirmButton: UIButton!

  let buttonBackgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.15)
  let cornerRadius = CGFloat(5.0)
  let outlineColor1 = UIColor(red: 0.443, green: 0.961, blue: 0.082, alpha: 0.2).CGColor
  let outlineColor2 = UIColor(red: 0.443, green: 0.961, blue: 0.082, alpha: 0.6).CGColor
  var shouldAnimate = false

    override func viewDidLoad() {
        super.viewDidLoad()
      self.confirmButton.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.15)
      self.confirmButton.layer.masksToBounds = true
      self.confirmButton.layer.cornerRadius = self.cornerRadius
      self.confirmButton.layer.borderWidth = 2.0
      self.confirmButton.layer.borderColor = self.outlineColor1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(false)

    self.shouldAnimate = true

    var layers = [CALayer]()
    layers.append(self.confirmButton.layer)

    self.doButtonPulseAnim(layers)
    
  }

  func doButtonPulseAnim(layers: [CALayer]) {
    if self.shouldAnimate {
      let theAnimation = CABasicAnimation(keyPath: "borderColor")
      theAnimation.delegate = self

      println("here in core animation")
      theAnimation.repeatCount = 10000.0
      theAnimation.autoreverses = true
      theAnimation.fromValue = self.outlineColor1
      theAnimation.toValue = self.outlineColor2
      for layer in layers {
        theAnimation.duration = 1.0
        layer.addAnimation(theAnimation, forKey: "borderColor")
        layer.borderColor = outlineColor2
      }
    }
  }
    
  @IBAction func didPressButton(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }




}
