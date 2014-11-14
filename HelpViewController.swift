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

  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var restartButton: UIButton!
  @IBOutlet weak var vibrationSwitch: UISwitch!
  @IBOutlet weak var numberOfAgentsLabel: UILabel!

  var logFor = LogClass()


  override func viewDidLoad() {
    super.viewDidLoad()
    restartButton.addBorder()
    doneButton.addBorder()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
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
  
  @IBAction func restartButtonPressed(sender: AnyObject) {
    let alert = UIAlertController(title: nil, message: "Do you really want to leave the game? ", preferredStyle: UIAlertControllerStyle.Alert)
    
    let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action) -> Void in
      self.restartGame()
    }
    
    let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (action) -> Void in
      alert.dismissViewControllerAnimated(true, completion: nil)
    }
    
    alert.addAction(ok)
    alert.addAction(cancel)
    self.presentViewController(alert, animated: true, completion: nil)
  }

  @IBAction func doneButtonPressed(sender: AnyObject) {
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  func restartGame() {
    logFor.DLog("RESTART PRESSED!")
    
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    let launchVC = storyboard.instantiateViewControllerWithIdentifier("LAUNCHVIEW_VC") as LaunchViewController
    launchVC.resetForNewGame()
    appDel.window!.rootViewController = launchVC
    
    
  }
  
  @IBAction func switchSwitched(sender: UISwitch) {
    
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "vibrationOn")
    NSUserDefaults.standardUserDefaults().synchronize()

  }
  

}
