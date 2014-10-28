//
//  LaunchViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
  
  var masterController : LeadGameController?
  var followerController : GameController?
    var multiPeerController = MultiPeerController.sharedInstance

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
    startButton.hidden = false
    peersLabel.hidden = false
    joinButton.hidden = true
    hostButton.hidden = true
    masterController = LeadGameController()
    masterController?.startLookingForPlayers()
    
  }

  @IBAction func joinGameButtonPressed(sender: AnyObject) {
    joinButton.hidden = true
    hostButton.hidden = true
    self.spinningWheel.startAnimating()
    followerController = GameController()
    multiPeerController.startAdvertising()
    
  }
  
  @IBAction func startGameButtonPressed(sender: AnyObject) {
    println("Going to start game!")
    
  }
    
    func updateConnectedPeersLabel (number: Int) -> Void
    {
        self.peersLabel.text = "[" + number.description + " Peers Connected..]"
    }
  
}
