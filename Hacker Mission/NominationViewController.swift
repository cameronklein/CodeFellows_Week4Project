//
//  CharacterRevealController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class NominationVoteViewController: UIViewController {
  
    @IBOutlet weak var nominatedPlayers : UILabel!
    var nominatedPlayersAray : [Player]!
    
    override func viewDidAppear(animated: Bool) {
        var playerNames : NSString
        for player in nominatedPlayersAray {
            playerNames = playerNames + " " + player.name
        }
        nominatedPlayers.text = playerNames
    }
    
    @IBAction func approveNominatedTeam (sender: AnyObject){
        
    }
    
    @IBAction func rejectNominatedTeam (sender: AnyObject){
        
    }
    
    
}
