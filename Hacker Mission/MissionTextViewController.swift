//
//  MissionTextViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class MissionTextViewController: UIViewController {

  @IBOutlet weak var missionFlavorTextLabel: UILabel!
  @IBOutlet weak var leaderSelectingTeam: UILabel!
  @IBOutlet weak var missionFlavorTextDescriptionLabel: UILabel!
  
  var gameController = GameController.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let currentMission = gameController.game.missions[gameController.game.currentMission] as Mission
    missionFlavorTextLabel.text = currentMission.missionName
    missionFlavorTextDescriptionLabel.text = currentMission.missionDescription
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func confirmButtonPressed(sender: AnyObject) {
    let parentVC = self.parentViewController as HomeViewController
    parentVC.nominatePlayers()
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
 
}
