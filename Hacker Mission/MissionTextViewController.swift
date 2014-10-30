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
  
  var game : GameSession!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let currentMission = game.missions[game.currentMission!] as Mission
    missionFlavorTextLabel.text = currentMission.missionDescription
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
