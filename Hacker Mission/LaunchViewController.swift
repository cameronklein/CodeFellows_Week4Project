//
//  LaunchViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, CharacterCreationViewDelegate {
  
  var masterController    : LeadGameController?
  var followerController  : GameController?
  var userInfoMyself : UserInfo?
  //var multiPeerController = MultiPeerController.sharedInstance

  @IBOutlet weak var peersLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var hostButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  @IBOutlet weak var spinningWheel: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    }


  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  @IBAction func hostGameButtonPressed(sender: AnyObject) {
    startButton.hidden = true
    peersLabel.hidden = false
    joinButton.hidden = true
    hostButton.hidden = true
    masterController = LeadGameController()
    masterController?.startLookingForPlayers()
    masterController?.launchVC = self
    
  }

  @IBAction func joinGameButtonPressed(sender: AnyObject) {
    joinButton.hidden = true
    hostButton.hidden = true
    self.spinningWheel.startAnimating()
    followerController = GameController()
    followerController?.startLookingForGame()
    followerController?.launchVC = self
    
  }
  
  @IBAction func startGameButtonPressed(sender: AnyObject) {
    println("Going to start game!")
    masterController?.startGame()
  }
    
    func updateConnectedPeersLabel (number: Int) -> Void
    {
        println("updating Peers Label to \(number)")
        self.peersLabel.text = "[" + number.description + " Peers Connected..]"
        if (number > 0) {
            println("Yep, number is greater then 0")
            println(self.spinningWheel.isAnimating())
            if (self.spinningWheel.isAnimating()){
                self.spinningWheel.stopAnimating()
                self.peersLabel.hidden = false
            }
        }
        if (number > 0) {
            if (self.masterController != nil) {
                self.startButton.hidden = false
            }
        }
        
    
    }
  
  func gameStart(revealVC: RevealViewController) {
    
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.presentViewController(revealVC, animated: true, completion: nil)
    }
  }
    
    func didSaveUser(userToSave: UserInfo) {
        self.userInfoMyself = userToSave
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_CHARCREATE" {
            let destinationVC = segue.destinationViewController as CharacterCreationViewController
            destinationVC.delegate = self
        }
    }
    
    
    @IBAction func createCharacter(sender: AnyObject) {
        self.performSegueWithIdentifier("SHOW_CHARCREATE", sender: self)
    }
}
