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
  var game : GameSession!
  
  override func viewDidLoad() {
    super.viewDidLoad()
 
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let justCompletedMission = game.missions[game.currentMission - 1] as Mission
    let result = justCompletedMission.success! as Bool
    let successVotes = justCompletedMission.successCardsPlayed
    let failVotes = justCompletedMission.failCardsPlayed
    if result {
      missionOutcomeLabel.text = "Mission Succeeded with a vote of \(successVotes) to \(failVotes)!"
    } else {
      missionOutcomeLabel.text = "Mission Failed with a vote of \(failVotes) to \(successVotes)"
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func confirmButtonPressed(sender: AnyObject) {
    let parentVC = self.parentViewController as HomeViewController
 
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
    parentVC.processEndMission()
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
