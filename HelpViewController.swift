//
//  HelpViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/7/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
  
  
  @IBOutlet weak var numberOfAgentsLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  @IBAction func restartButtonPressed(sender: AnyObject) {
    let alert = UIAlertController(title: nil, message: "Do you really want to leave the game? ", preferredStyle: UIAlertControllerStyle.Alert)
    
    let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action) -> Void in
      self.restartGame()
    }
    
    let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  func restartGame() {
    UIApplication.sharedApplication().keyWindow?.rootViewController = LaunchViewController()
  }

}
