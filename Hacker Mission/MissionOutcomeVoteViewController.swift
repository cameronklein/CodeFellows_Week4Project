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
  var currentUser : Player!
  
  @IBOutlet weak var loyalLabel: UILabel!
  @IBOutlet weak var failButton: UIButton!
  @IBOutlet weak var succeedButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    failButton.enabled = true
    succeedButton.enabled = true
    loyalLabel.hidden = true

  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if currentUser.playerRole == .Hacker {
      loyalLabel.hidden = false
      failButton.enabled = false
    } else {
      loyalLabel.hidden = true
      failButton.enabled = true
    }
  }
  
  func disableButtons() {
    failButton.enabled = false
    succeedButton.enabled = false
  }
  
  @IBAction func successButtonPressed (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "succeed"])
    disableButtons()
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  @IBAction func failButtonPressed (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "fail"])
    disableButtons()
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }

}
