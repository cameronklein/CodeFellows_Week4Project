//
//  CharacterRevealController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class NominationVoteViewController: UIViewController {
  
  var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
  
    @IBOutlet weak var nominatedPlayers : UILabel!
    var nominatedPlayersAray : [Player]!
    
    override func viewDidAppear(animated: Bool) {
        var playerNames = NSString()
        for player in nominatedPlayersAray {
            var playerStaged = player as Player
            playerNames = playerNames + " " + playerStaged.playerName
        }
        nominatedPlayers.text = playerNames
    }
    
    @IBAction func approveNominatedTeam (sender: AnyObject){
      multiPeerController.sendInfoToMainBrain(["vote" : true])
      
    }
    
    @IBAction func rejectNominatedTeam (sender: AnyObject){
      multiPeerController.sendInfoToMainBrain(["vote" : false])
    }
    
    
}
