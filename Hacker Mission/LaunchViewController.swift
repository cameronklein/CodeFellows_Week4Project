//
//  LaunchViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
  
  var masterController    : LeadGameController?
  var followerController  : GameController?
  var userInfoMyself      : UserInfo?
  var truthInAdvertising  : Bool?
  var multiPeerController = MultiPeerController.sharedInstance
  var originalButtonColor : UIColor!

  @IBOutlet weak var peersLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var hostButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  @IBOutlet weak var spinningWheel: UIActivityIndicatorView!
  @IBOutlet weak var createCharacterButton: UIButton!
  @IBOutlet weak var privacyPolicyButton: UIButton!
  @IBOutlet weak var hackerMissionTitle: UIImageView!
  @IBOutlet weak var flavorLabel: UILabel!
  

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
    startButton.alpha = 0.0
    startButton.enabled = false
    peersLabel.alpha = 0.0
    self.originalButtonColor = self.startButton.titleLabel!.textColor
    self.peersLabel.text = "Looking for other players..."
    
    
    
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(false)
    animateTitle(true)

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
//        destinationvVC.delegate = self
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

    self.flavorLabel.typeToNewString("The daring hackers of the Opposition have weakened the iron grip of the oppressive Government, just a few more incidents will incite revolution. Your battered laptop is the ultimate weapon for the hearts and minds of your fellow citizens...", withInterval: 0.05, startingText: "")
  }


  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  @IBAction func hostGameButtonPressed(sender: AnyObject) {
    self.switchUIElements(true)
    self.hostButton.hidden = true
    self.spinningWheel.startAnimating()
    masterController = LeadGameController()
    followerController = GameController.sharedInstance
    followerController?.launchVC = self
    masterController?.startLookingForPlayers()
    masterController?.launchVC = self
    
    
  }

  @IBAction func joinGameButtonPressed(sender: AnyObject) {
    self.switchUIElements(false)
    self.joinButton.hidden = true
    self.spinningWheel.startAnimating()
    followerController = GameController.sharedInstance
    followerController?.startLookingForGame()
    followerController?.launchVC = self

  }
  
  func switchUIElements(isHost : Bool) {
    self.peersLabel.hidden = false
    UIView.animateWithDuration(1.0, animations: { () -> Void in
      self.createCharacterButton.alpha = 0
      self.privacyPolicyButton.alpha = 0
      self.peersLabel.alpha = 1
      if isHost == true {
        self.startButton.alpha = 0.7
        self.startButton.titleLabel?.textColor = UIColor.grayColor()
        self.joinButton.alpha = 0
      } else {
        self.hostButton.alpha = 0
      }
    })
  }
  
  @IBAction func startGameButtonPressed(sender: AnyObject) {
    println("Going to start game!")
    masterController?.beginRequestingImagesFromPlayers()
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
        println("Showing start button")
        self.startButton.enabled = true
        startButton.alpha = 1.0
        startButton.titleLabel?.textColor = originalButtonColor
      }
    }
  }

  func gameStart(revealVC: RevealViewController) {
    
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.presentViewController(revealVC, animated: true, completion: nil)
    }
    
  }
    
//    func didSaveUser(userToSave: UserInfo) {
//      
//      self.userInfoMyself = userToSave
//      
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
      if segue.identifier == "SHOW_CHARCREATE" {
        let destinationVC = segue.destinationViewController as CharacterCreationViewController
        destinationVC.wasPresented = true
      }
      
    }
  
    @IBAction func createCharacter(sender: AnyObject) {
      self.performSegueWithIdentifier("SHOW_CHARCREATE", sender: self)
    }
  
  func animateTitle(isAtTop: Bool) {
    if isAtTop{
      UIView.animateWithDuration(2.0,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.hackerMissionTitle.frame.origin.y = self.hackerMissionTitle.frame.origin.y + 20
        },
        completion: { (success) -> Void in
          self.animateTitle(false)
      })
    } else {
      UIView.animateWithDuration(2.0,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.hackerMissionTitle.frame.origin.y = self.hackerMissionTitle.frame.origin.y - 20
        },
        completion: { (success) -> Void in
          self.animateTitle(true)
      })
    }
  }
  
  @IBAction func privacyPolicyButtonPressed(sender: AnyObject) {
    let PPVC = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle: NSBundle.mainBundle())
    self.presentViewController(PPVC, animated: true, completion: nil)
  }
  
}
