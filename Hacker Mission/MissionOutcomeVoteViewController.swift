//
//  MissionOutcomeVoteViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class MissionOutcomeVoteViewController: UIViewController {
  
  var gameController = GameController.sharedInstance
  var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
  var game : GameSession?
  var currentUser : Player!
  
  @IBOutlet weak var loyalLabel: UILabel!
  @IBOutlet weak var failButton: UIButton!
  @IBOutlet weak var succeedButton: UIButton!
  @IBOutlet weak var succeedOrFailLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    failButton.enabled = true
    failButton.addBorder()
    succeedButton.enabled = true
    succeedButton.addBorder()
    loyalLabel.hidden = true
    failButton.alpha = 1

  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if currentUser.playerRole == .Hacker {
      loyalLabel.hidden = false
      failButton.enabled = false
      failButton.alpha = 0.5
    } else {
      loyalLabel.hidden = true
      loyalLabel.transform = CGAffineTransformMakeRotation(340)
      failButton.enabled = true
    }
    
    var textToAnimate = self.succeedOrFailLabel.text!
    self.succeedOrFailLabel.typeToNewString(textToAnimate, withInterval: 0.1)
  }
  
  override func viewDidAppear(animated: Bool) {
    self.view.layer.cornerRadius = self.view.frame.size.width / 16
    self.view.layer.masksToBounds = true
  }
  
  func disableButtons() {
    failButton.enabled = false
    succeedButton.enabled = false
  }
  
  @IBAction func successButtonPressed (sender: AnyObject)
  {
    gameController.missionOutcomesVotedFor[gameController.game.currentMission] = true
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "succeed"])
    disableButtons()
    parentVC.nominationPromptLabel.text = "Waiting for other players..."
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  @IBAction func failButtonPressed (sender: AnyObject)
  {
    gameController.missionOutcomesVotedFor[gameController.game.currentMission] = true
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "fail"])
    disableButtons()
    parentVC.nominationPromptLabel.text = "Waiting for other players..."
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }

}
