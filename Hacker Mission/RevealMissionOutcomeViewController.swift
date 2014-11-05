//
//  RevealMissionOutcomeViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class RevealMissionOutcomeViewController: UIViewController {

  @IBOutlet weak var missionOutcomeLabel: UILabel!
  @IBOutlet weak var missionOutcomeTitleLabel: UILabel!
  
  var gameController = GameController.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let justCompletedMission = gameController.game.missions[gameController.game.currentMission - 1] as Mission
    let result = justCompletedMission.success! as Bool
    let successVotes = justCompletedMission.successCardsPlayed
    let failVotes = justCompletedMission.failCardsPlayed
    
    missionOutcomeTitleLabel.text = justCompletedMission.missionName
    if result {
      missionOutcomeLabel.text = "Mission succeeded! with a vote of \(successVotes) to \(failVotes)!"
    } else {
      missionOutcomeLabel.text = "Mission Failed with a vote of \(failVotes) to \(successVotes)"
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidAppear(animated: Bool) {
    self.view.layer.cornerRadius = self.view.frame.size.width / 16
    self.view.layer.masksToBounds = true
  }
  
  @IBAction func confirmButtonPressed(sender: AnyObject) {
    let parentVC = self.parentViewController as HomeViewController
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
    parentVC.processEndMission()
  }
  
}
