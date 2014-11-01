//
//  EndGameViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/31/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

  @IBOutlet weak var gameOutcomeLabel: UILabel!
  
  let gameController = GameController.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()

      // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let game = gameController.game
    
    if game.passedMissionCount == 3 {
      gameOutcomeLabel.text = "Hackers win the day!!!11"
    } else if game.failedMissionCount == 3 {
      gameOutcomeLabel.text = "Hackers have been foiled and are rotting away in jail."
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}
