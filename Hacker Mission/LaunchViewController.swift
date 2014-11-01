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
  var userInfoMyself      : UserInfo?
  var truthInAdvertising  : Bool?
  var multiPeerController = MultiPeerController.sharedInstance

  @IBOutlet weak var peersLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var hostButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  @IBOutlet weak var spinningWheel: UIActivityIndicatorView!
  @IBOutlet weak var createCharacterButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let myUserTest = appDelegate.defaultUser as UserInfo!
    if myUserTest != nil {
      println("existing defaultUser is \(appDelegate.defaultUser?.userName)")
      self.userInfoMyself = appDelegate.defaultUser
    } else {
      self.userInfoMyself = nil
    }

  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(false)

  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if self.userInfoMyself == nil {
      if self.truthInAdvertising != true {
        self.truthInAdvertising = true
        println("no userInfoMyself")
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let destinationvVC = storyboard.instantiateViewControllerWithIdentifier("CHARCREATE_VC") as CharacterCreationViewController!
        let presentingVC = storyboard.instantiateViewControllerWithIdentifier("LAUNCHVIEW_VC") as LaunchViewController!
        destinationvVC.delegate = self
        self.presentViewController(destinationvVC, animated: false, completion: { () -> Void in
          println("yes!")
        })
      }


    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(false)
    println("viewDidAppear")
    println("user is \(self.userInfoMyself?.userName)")
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    println("the appDelUser is: \(appDelegate.defaultUser?.userName)")
  }


  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  @IBAction func hostGameButtonPressed(sender: AnyObject) {
    startButton.hidden = true
    peersLabel.hidden = false
    peersLabel.text = "Looking for other players..."
    joinButton.hidden = true
    hostButton.hidden = true
    self.spinningWheel.startAnimating()
    masterController = LeadGameController()
    followerController = GameController.sharedInstance
    followerController?.launchVC = self
    masterController?.startLookingForPlayers()
    masterController?.launchVC = self
    createCharacterButton.hidden = true
    
  }

  @IBAction func joinGameButtonPressed(sender: AnyObject) {
    joinButton.hidden = true
    hostButton.hidden = true
    peersLabel.hidden = false
    peersLabel.text = "Looking for other players..."
    self.spinningWheel.startAnimating()
    followerController = GameController.sharedInstance
    followerController?.startLookingForGame()
    followerController?.launchVC = self
    createCharacterButton.hidden = true
    followerController?.sendUserInfo()
  }
  
  @IBAction func startGameButtonPressed(sender: AnyObject) {
    println("Going to start game!")
    masterController?.startGame()
  }
    
  func updateConnectedPeersLabel (number: Int) -> Void
  {
    println("LAUNCH VIEW CONTROLLER: Updating peers label to \(number)")
    self.peersLabel.text = "[" + number.description + " Peers Connected..]"
    if (number > 0) {
      println(self.spinningWheel.isAnimating())
      if (self.spinningWheel.isAnimating()){
        self.spinningWheel.stopAnimating()
        self.peersLabel.hidden = false
      }
      if self.masterController != nil {
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
