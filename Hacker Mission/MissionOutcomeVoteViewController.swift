//
//  MissionOutcomeVoteViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class MissionOutcomeVoteViewController: UIViewController {
  
  var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
  var game : GameSession?
  
  override func viewDidAppear(animated: Bool) {

  }
  
  @IBAction func successButtonPressed (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "succeed"])
  }
  
  @IBAction func failButtonPressed (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "fail"])
  }

}
