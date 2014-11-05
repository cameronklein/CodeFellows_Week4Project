//
//  LaunchViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import QuartzCore

class LaunchViewController: UIViewController {

  let buttonBackgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.15)
  let cornerRadius = CGFloat(5.0)
  let outlineColor1 = UIColor(red: 0.443, green: 0.961, blue: 0.082, alpha: 0.2).CGColor
  let outlineColor2 = UIColor(red: 0.443, green: 0.961, blue: 0.082, alpha: 0.6).CGColor


  var masterController    : LeadGameController?
  var followerController  : GameController?
  var userInfoMyself      : UserInfo?
  var truthInAdvertising  : Bool?
  var multiPeerController = MultiPeerController.sharedInstance
  var originalButtonColor : UIColor!
  var imageAnchorX = CGFloat()
  var imageAnchorY = CGFloat()
  var startedOnce = false
  var shouldAnimate = false

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

    self.imageAnchorX = self.hackerMissionTitle.frame.origin.x
    self.imageAnchorY = self.hackerMissionTitle.frame.origin.y

    self.createCharacterButton.titleLabel?.textAlignment = NSTextAlignment.Center
    self.createCharacterButton.backgroundColor = self.buttonBackgroundColor
    self.createCharacterButton.layer.masksToBounds = true
    self.createCharacterButton.layer.cornerRadius = self.cornerRadius
    self.createCharacterButton.layer.borderWidth = 2.0
    self.createCharacterButton.layer.borderColor = self.outlineColor1

    self.privacyPolicyButton.titleLabel?.textAlignment = NSTextAlignment.Center
    self.privacyPolicyButton.backgroundColor = self.buttonBackgroundColor
    self.privacyPolicyButton.layer.masksToBounds = true
    self.privacyPolicyButton.layer.cornerRadius = self.cornerRadius
    self.privacyPolicyButton.layer.borderWidth = 2.0
    self.privacyPolicyButton.layer.borderColor = self.outlineColor1

    self.joinButton.backgroundColor = self.buttonBackgroundColor
    self.joinButton.layer.masksToBounds = true
    self.joinButton.layer.cornerRadius = self.cornerRadius
    self.joinButton.layer.borderWidth = 2.0
    self.joinButton.layer.borderColor = self.outlineColor1

    self.hostButton.backgroundColor = self.buttonBackgroundColor
    self.hostButton.layer.masksToBounds = true
    self.hostButton.layer.cornerRadius = self.cornerRadius
    self.hostButton.layer.borderWidth = 2.0
    self.hostButton.layer.borderColor = self.outlineColor1

    self.startButton.backgroundColor = self.buttonBackgroundColor
    self.startButton.layer.masksToBounds = true
    self.startButton.layer.cornerRadius = self.cornerRadius
    self.startButton.layer.borderWidth = 2.0
    self.startButton.layer.borderColor = self.outlineColor1


  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(false)
//    animateTitle(true)

  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.shouldAnimate = false
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(false)

    self.shouldAnimate = true

    println("viewDidAppear")
    println("user is \(self.userInfoMyself?.userName)")
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    println("the appDelUser is: \(appDelegate.defaultUser?.userName)")

    var layers = [CALayer]()
    layers.append(self.hostButton.layer)
    layers.append(self.createCharacterButton.layer)
    layers.append(self.joinButton.layer)
    layers.append(self.privacyPolicyButton.layer)
    self.doAnim(layers)

    self.typingAnimation()
    self.titleAnimation()

  }

  func doAnim(layers: [CALayer]) {
    if self.shouldAnimate {
      let theAnimation = CABasicAnimation(keyPath: "borderColor")
      theAnimation.delegate = self

      println("here in core animation")
      theAnimation.repeatCount = 10000.0
      theAnimation.autoreverses = true
      theAnimation.fromValue = self.outlineColor1
      theAnimation.toValue = self.outlineColor2
      for layer in layers {
        let rvalue = Float(arc4random_uniform(10) + 1)
        println("rvalue is \(rvalue)")
        let rvalueFor = Double(rvalue / 10.0)
        println(rvalueFor)

        theAnimation.duration = 1.0 // + rvalueFor
        layer.addAnimation(theAnimation, forKey: "borderColor")
        layer.borderColor = outlineColor2
      }
    }
  }



  func typingAnimation() {
    if self.shouldAnimate {
      self.flavorLabel.typeToNewString("The daring hackers of the Opposition have weakened the iron grip of the oppressive Government. Just a few more incidents will incite a revolution. Your battered laptop is the ultimate weapon for the hearts and minds of your fellow citizens...", withInterval: 0.05, startingText: "")
      self.startedOnce = true
    }
  }

  func titleAnimation() {
    var imageView = self.hackerMissionTitle
    imageView.reloadInputViews()
    let imageAnchorX = self.imageAnchorX
    let imageAnchorY = self.imageAnchorY
    var delay = Double(arc4random_uniform(40) + 3) / 10.0

    if shouldAnimate {
      UIView.animateKeyframesWithDuration(0.1, delay: delay, options: nil, animations: { () -> Void in

        UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.70, animations: { () -> Void in
          println("first")
          println("and a half")
          //        imageView.frame.origin.x = imageAnchorX
          //        imageView.frame.origin.y = imageAnchorY
        })
        UIView.addKeyframeWithRelativeStartTime(0.70, relativeDuration: 0.1, animations: { () -> Void in
          println("second")
          let xSeed = arc4random_uniform(101)
          let ySeed = arc4random_uniform(81)
          var intSeedX = Int(xSeed)
          var intSeedY = Int(ySeed)
          intSeedX = intSeedX - 50
          intSeedY = intSeedY - 40
          let xVar = CGFloat(intSeedX)
          let yVar = CGFloat(intSeedY)
          println("xVar is \(xVar) and yVar is \(yVar)")
          imageView.frame.origin.x = imageAnchorX + xVar
          imageView.frame.origin.y = imageAnchorY + yVar
          println("imageAnchorY is \(imageAnchorY)")
          println("imageview frame origin y is \(imageView.frame.origin.y)")
        })
        UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.05, animations: { () -> Void in
          imageView.frame.origin.x = imageAnchorX
          imageView.frame.origin.y = imageAnchorY
          println("third step")
        })
        }) { (Finished) -> Void in
          println("done")
          self.pauseTimerFor()
          
      }
    }


  }

  func pauseTimerFor() {
    println("pausetimer")
    var delay = Double(arc4random_uniform(40) + 3) / 10.0
    var pauseTimer = NSTimer(timeInterval: delay, target: self, selector: "titleAnimation", userInfo: nil, repeats: false)
    println("got this far")
    pauseTimer.fire()
    println("paused")
    pauseTimer.invalidate()
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
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
      if segue.identifier == "SHOW_CHARCREATE" {
        let destinationVC = segue.destinationViewController as CharacterCreationViewController
        destinationVC.wasPresented = true
      }
      
    }
  
    @IBAction func createCharacter(sender: AnyObject) {
      self.performSegueWithIdentifier("SHOW_CHARCREATE", sender: self)
    }
  


  @IBAction func privacyPolicyButtonPressed(sender: AnyObject) {
    let PPVC = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle: NSBundle.mainBundle())
    self.presentViewController(PPVC, animated: true, completion: nil)
  }
  
}
