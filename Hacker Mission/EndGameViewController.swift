//
//  EndGameViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/31/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

  @IBOutlet weak var gameOutcomeTitle: UILabel!
  @IBOutlet weak var gameOutcomeLabel: UILabel!
  @IBOutlet weak var restartButton: UIButton!
  
  let gameController = GameController.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let game = gameController.game
    
    if game.passedMissionCount == 3 {
      if gameController.thisPlayer.playerRole == .Agent {
        gameOutcomeTitle.text = "You Lose!"
        gameOutcomeLabel.text = "You hear the din of the populace coming alive. Storming of government buildings has already begun. It will not be long before the social structure is overthrown. And, more importantly to you, before records of your government involvement are discovered. Better get out of town. And soon."
      } else {
        gameOutcomeLabel.text = "The populace has come alive, storming the streets in hopes of storming government buildings. It has begun. When day breaks, the government will be no more. Underground news is rife with tales of your exploits. You are adored. There is a leadership vacuum for the taking. Will you step up?"
      }
      
    } else if game.failedMissionCount == 3 {
      if gameController.thisPlayer.playerRole == .Hacker {
        gameOutcomeTitle.text = "You Lose!"
      }
      gameOutcomeLabel.text = "Hackers have been foiled and are rotting away in jail."
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func didPressRestart(sender: UIButton) {
    
    let parentVC = self.parentViewController as HomeViewController
    
    UIView.animateWithDuration(1.0,
      delay: 0.4,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
      parentVC.view.alpha = 0
      return ()
    }) { (success) -> Void in
      let launchVC = LaunchViewController()
      launchVC.resetForNewGame()
      UIApplication.sharedApplication().keyWindow?.rootViewController = launchVC
    }
    
    
  }

}
