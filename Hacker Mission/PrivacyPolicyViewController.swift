//
//  PrivacyPolicyViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/4/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func confirmButtonPressed(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

}
