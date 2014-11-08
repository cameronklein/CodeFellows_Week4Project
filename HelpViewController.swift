//
//  HelpViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/7/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
  
  var gameController = GameController.sharedInstance
  
  @IBOutlet weak var vibrationSwitch: UISwitch!
  @IBOutlet weak var numberOfAgentsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    switch gameController.game.players.count{
    case 5, 6:
    numberOfAgentsLabel.text = 2.description
    case 7, 8, 9:
    numberOfAgentsLabel.text = 3.description
    case 10:
    numberOfAgentsLabel.text = 4.description
    default:
    numberOfAgentsLabel.text = 1.description
    }

    vibrationSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("vibrationOn")
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
  
  @IBAction func switchSwitched(sender: UISwitch) {
    
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "vibrationOn")
    NSUserDefaults.standardUserDefaults().synchronize()

  }
  

}
