//
//  OnboardPageViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/2/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

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
      } 
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


}
