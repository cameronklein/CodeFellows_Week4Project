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
  
    var nominatedPlayersArray : [Player]!
    
    override func viewDidAppear(animated: Bool) {
        var playerNames = NSString()
        for player in nominatedPlayersArray {
            var playerStaged = player as Player
            playerNames = playerNames + " " + playerStaged.playerName
        }
    }
    
    @IBAction func approveNominatedTeam (sender: AnyObject)
    {
      multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : true])
    }
    
    @IBAction func rejectNominatedTeam (sender: AnyObject)
    {
      multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : false])
    }
    
    
}
