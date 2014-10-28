//
//  LaunchViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
  
  var multipeerController = MultiPeerController.sharedInstance

  @IBOutlet weak var peersLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var hostButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  @IBOutlet weak var spinningWhee: UIActivityIndicatorView!
  
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
    multipeerController.startBrowsing()
    
  }

  @IBAction func joinGameButtonPressed(sender: AnyObject) {
    joinButton.hidden = true
    hostButton.hidden = true
    self.spinningWhee.startAnimating()
    multipeerController.startAdvertising()
    
  }
  
  @IBAction func startGameButtonPressed(sender: AnyObject) {
    
  }
  
  
}
