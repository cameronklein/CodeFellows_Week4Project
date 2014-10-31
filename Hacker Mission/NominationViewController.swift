//
//  CharacterRevealController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class NominationVoteViewController: UIViewController//, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var nominatedPlayerViewContoller : UICollectionView!
    var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
    var game : GameSession!
  
    var nominatedPlayersArray : [Player]!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let currentMission = game.missions[game.currentMission] as Mission
    nominatedPlayersArray = currentMission.nominatedPlayers
  }
    
    override func viewDidAppear(animated: Bool) {
        var playerNames = NSString()
        for player in nominatedPlayersArray {
            var playerStaged = player as Player
            playerNames = playerNames + " " + playerStaged.playerName
        }
    }
    
    @IBAction func approveNominatedTeam (sender: AnyObject)
    {
      multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : "Approve"])
      self.view.removeFromSuperview()
      self.removeFromParentViewController()
    }
    
    @IBAction func rejectNominatedTeam (sender: AnyObject)
    {
      multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : "Reject"])
      self.view.removeFromSuperview()
      self.removeFromParentViewController()
    }
    
    
}
