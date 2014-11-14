//
//  MissionTextViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class MissionTextViewController: UIViewController {

  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var missionFlavorTextLabel: UILabel!
  @IBOutlet weak var missionFlavorTextDescriptionLabel: UILabel!
  
  var gameController = GameController.sharedInstance
  var logFor = LogClass()


  override func viewDidLoad() {
    super.viewDidLoad()
    button.addBorder()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let currentMission = gameController.game.missions[gameController.game.currentMission] as Mission
    missionFlavorTextLabel.text = currentMission.missionName
    missionFlavorTextDescriptionLabel.text = currentMission.missionDescription
  }

  override func viewDidAppear(animated: Bool) {
    self.view.layer.cornerRadius = self.view.frame.size.width / 16
    self.view.layer.masksToBounds = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func confirmButtonPressed(sender: AnyObject) {
    let parentVC = self.parentViewController as HomeViewController
    parentVC.nominatePlayers()
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
 
}
