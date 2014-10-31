//
//  MissionOutcomeVoteViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class MissionOutcomeVoteViewController: UIViewController {
  
  var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
  var game : GameSession?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let label = UILabel(frame: CGRect(x: 30, y: 30, width: 100, height: 100))
    label.text = "Well, fart on a poptart. Why isn't the view loading?"
    self.view.addSubview(label)
    view.backgroundColor = UIColor.blueColor()
    println("View did load!")
  }
  
  override func viewDidAppear(animated: Bool) {

  }
  
  @IBAction func successButtonPressed (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "succeed"])
  }
  
  @IBAction func failButtonPressed (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "missionOutcome", "value" : "fail"])
  }

}
