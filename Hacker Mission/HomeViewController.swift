//
//  HomeViewController.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
  //MARK: - Outlets and Properties
  @IBOutlet weak var incomingMesageLabel: UILabel!
  @IBOutlet weak var playersCollectionView: UICollectionView!
  @IBOutlet weak var mission1ImageView: UIImageView!
  @IBOutlet weak var mission1OutcomeLabel: UILabel!
  @IBOutlet weak var mission1to2TransitionImageView: UIImageView!
  @IBOutlet weak var mission2ImageView: UIImageView!
  @IBOutlet weak var mission2OutcomeLabel: UILabel!
  @IBOutlet weak var mission2To3TransitionImageView: UIImageView!
  @IBOutlet weak var mission3ImageView: UIImageView!
  @IBOutlet weak var mission3OutcomeLabel: UILabel!
  @IBOutlet weak var mission3To4TransitionImageView: UIImageView!
  @IBOutlet weak var mission4ImageView: UIImageView!
  @IBOutlet weak var mission4OutcomeLabel: UILabel!
  @IBOutlet weak var mission4To5TransitionImageView: UIImageView!
  @IBOutlet weak var mission5ImageView: UIImageView!
  @IBOutlet weak var mission5OutcomeLabel: UILabel!
  @IBOutlet weak var missionView: UIView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var votingResultsIndicatorLabel: UILabel!
  @IBOutlet weak var nominationPromptLabel: UILabel!
  @IBOutlet weak var confirmNominationButton: UIButton!
  @IBOutlet weak var gearButton: UIButton!
  
  var multiPeerController = MultiPeerController.sharedInstance
  var gameController = GameController.sharedInstance

  var playersSelected = 0
  var labelsAreBlinking = false
  var lastRejectedGameCount = 0
  var screenWidth : CGFloat!
  var layout : UICollectionViewFlowLayout!
  var missionLabelArray : [UILabel]!
  var selectedIndexPath : NSIndexPath?
  
  //MARK: - Lifecycle Methods
  
  override func viewDidLoad()
    {
      super.viewDidLoad()
      self.setupCollectionView()
      
      gameController.homeVC = self
      gearButton.titleLabel!.text = "\u{F013}"
      
      confirmNominationButton.addBorder()
      
      missionLabelArray = [mission1OutcomeLabel, mission2OutcomeLabel, mission3OutcomeLabel, mission4OutcomeLabel, mission5OutcomeLabel]
      
      //Round corners on missions view
      self.missionView.layer.cornerRadius = self.missionView.frame.size.width / 32
      self.missionView.layer.masksToBounds = true
      
    }

    //MARK: - Collection View Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      return self.gameController.game.players.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
      let player = self.gameController.game.players[indexPath.row] as Player
      let imagePacketImage = self.findMatchingImageForPlayer(player, imagePacketArray: self.gameController.imagePackets)

      cell.imageView.image = imagePacketImage as UIImage!
      cell.username.text = player.playerName
      
      cell.layer.borderColor = UIColor.blackColor().CGColor
      cell.layer.borderWidth = 0
      
      if player.isNominated
      {
          cell.layer.borderColor = UIColor.greenColor().CGColor
          cell.layer.borderWidth = 1
      }

      if self.gameController.game.currentGameState != .RevealVote
      {
        cell.approvesMission.hidden = true
        cell.rejectsMission.hidden = true
      } else {
      
        if player.currentVote != nil
        {
          println("Found a currentVote")
        
          if (player.currentVote == true)
          {
              cell.approvesMission.alpha = 0
              cell.approvesMission.hidden = false
              cell.rejectsMission.hidden = true
              UIView.animateWithDuration(1, animations:
              { () -> Void in
                  cell.approvesMission.alpha = 1
              })
          }
          else
          {
              cell.rejectsMission.alpha = 0
              cell.rejectsMission.hidden = false
              cell.approvesMission.hidden = true
              UIView.animateWithDuration(1, animations:
              { () -> Void in
                  cell.rejectsMission.alpha = 1
              })
          }
        }
        else
        {
          println("Found nil for currentVote")
            cell.rejectsMission.hidden = true
            cell.approvesMission.hidden = true
        }
      }
      
      if player.isLeader == true {
        cell.leaderStar.hidden = false
      } else if player.isLeader == false {
        cell.leaderStar.hidden = true
      }
      
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      
      var currentState = gameController.game.currentGameState
      
      var isOneOfAcceptedGameStates = (currentState == .NominatePlayers || currentState == .MissionStart || currentState == .RevealCharacters || currentState == .RevealMissionOutcome)
      
      if self.gameController.thisPlayer.isLeader == true && isOneOfAcceptedGameStates {
        
        var player = gameController.game.players[indexPath.row]
        
        if player.isNominated == true
        {
            player.isNominated = false
            self.playersSelected -= 1
            self.playersCollectionView.reloadData()
        }
        else
        {
          if self.playersSelected == (self.gameController.game.missions[self.gameController.game.currentMission] as Mission).playersNeeded
          {
            println("You can't select this person until you deselect somebody else.")
          }
          else
          {
            player.isNominated = true
            self.playersSelected += 1
          }
          self.playersCollectionView.reloadData()
        }
        
        
        if self.playersSelected == (self.gameController.game.missions[self.gameController.game.currentMission] as Mission).playersNeeded
        {
            self.confirmNominationButton.userInteractionEnabled = true
            UIView.animateWithDuration(0.2, animations:
            { () -> Void in
                self.confirmNominationButton.titleLabel?.textColor = UIColor.greenColor()
                return ()
            })
            
        } else if self.confirmNominationButton.userInteractionEnabled == true {
          self.confirmNominationButton.userInteractionEnabled = false
          UIView.animateWithDuration(0.2, animations:
            { () -> Void in
              self.confirmNominationButton.titleLabel?.textColor = UIColor.lightGrayColor()
              return ()
          })
        }
      }
    }
  
  func setupCollectionView() {
    
    //Set delegate / data source
    self.playersCollectionView.delegate = self
    self.playersCollectionView.dataSource = self
    
    //Set Cell Dimensions
    self.layout = playersCollectionView.collectionViewLayout as UICollectionViewFlowLayout
    self.screenWidth = self.playersCollectionView.frame.width
    super.viewWillAppear(true)
    layout.minimumLineSpacing = screenWidth * 0.02
    layout.minimumInteritemSpacing = screenWidth * 0.02
    layout.sectionInset.left = screenWidth * 0.05
    layout.sectionInset.right = screenWidth * 0.05
    layout.itemSize = CGSize(width: screenWidth * 0.13, height: screenWidth * 0.17)
    
    //Register PlayerCellNib
    self.playersCollectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
    
    //Round corners on players collection view
    self.playersCollectionView.layer.cornerRadius = self.playersCollectionView.frame.size.width / 16
    self.playersCollectionView.layer.masksToBounds = true
    
  }
  
  func revealVotes() {
    
    let game = gameController.game
    let currentMission = game.missions[game.currentMission] as Mission
    var incomingMessageLabel = "Team Approved!"
    if currentMission.rejectedTeamsCount > self.lastRejectedGameCount {
      incomingMessageLabel = "Team Rejected!"
    }
    nominationPromptLabel.hidden = false
    self.countdownLabel()
    self.lastRejectedGameCount = currentMission.rejectedTeamsCount
    self.animateIncomingMessageLabel(incomingMessageLabel, completionHandler: { () -> (Void) in
      return ()
    })
  }

  func findMatchingImageForPlayer(player: Player, imagePacketArray: [ImagePacket]) -> UIImage {
    
    var imageFor : UIImage?
    let idToTest = player.peerID as NSString
    for imagePacket in imagePacketArray {
      if imagePacket.userPeerID == idToTest {
        imageFor = imagePacket.userImage as UIImage!
      }
    }

    return imageFor!
  }
  
    //MARK: - Actions and other functions
  
  func nominatePlayers() {
    
    let game = gameController.game
    self.playersSelected = 0
    var incomingMessageText = "\(game.leader!.playerName) is mission leader."
    if self.gameController.thisPlayer.isLeader == true {
      incomingMessageText = "You are mission leader. Nominate \((game.missions[game.currentMission] as Mission).playersNeeded) people."
    }
    
    self.animateIncomingMessageLabel(incomingMessageText, completionHandler: { () -> (Void) in
      
      self.playersCollectionView.reloadData()
      if self.gameController.thisPlayer.isLeader == true {
        self.nominationPromptLabel.text = "Nominate \((game.missions[game.currentMission] as Mission).playersNeeded) hackers to send on this mission."
        self.nominationPromptLabel.hidden = false
        self.confirmNominationButton.hidden = false
        self.nominationPromptLabel.alpha = 0
        self.confirmNominationButton.alpha = 0
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.nominationPromptLabel.alpha = 1
            self.confirmNominationButton.alpha = 1
          })
        })
        //self.startBlinking(self.nominationPromptLabel)
        self.confirmNominationButton.userInteractionEnabled = false
        self.playersCollectionView.userInteractionEnabled = true
      }
      else
      {
        self.nominationPromptLabel.hidden = false
        self.nominationPromptLabel.alpha = 0
        self.nominationPromptLabel.text = "Nominations being selected..."
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.nominationPromptLabel.alpha = 1
          })
        })
        
        //self.startBlinking(self.nominationPromptLabel)
      }
      
    })

  }
  
  @IBAction func confirmNominations(sender: AnyObject) {
    
    println("Confirmed Button Pressed")
      self.playersCollectionView.userInteractionEnabled = false
      self.confirmNominationButton.userInteractionEnabled = false
      self.confirmNominationButton.titleLabel?.textColor = UIColor.grayColor()
      self.labelsAreBlinking = false
      self.nominationPromptLabel.hidden = true
      self.confirmNominationButton.hidden = true
    
    
      var nominatedPlayerIDs = [String]()
      for player in gameController.game.players {
        if player.isNominated == true {
          nominatedPlayerIDs.append(player.peerID)
        }
      }
    let dict = NSMutableDictionary()
    dict.setObject("nominations", forKey: "action")
    dict.setObject(nominatedPlayerIDs, forKey: "value")
    println("Sending nomination information with players: \(nominatedPlayerIDs.description)")
    self.multiPeerController.sendInfoToMainBrain(dict)

  }
  
  func voteOnProposedTeam(){
    
    self.labelsAreBlinking = false
    self.nominationPromptLabel.hidden = true
    let currentMissionIndex = gameController.game.currentMission
    let currentMission = gameController.game.missions[currentMissionIndex]
    var didVote = gameController.teamsVotedFor[currentMissionIndex][currentMission.rejectedTeamsCount]
    
    if didVote == false {
      
      self.animateIncomingMessageLabel("Nominations Are In", completionHandler: { () -> (Void) in
        let vc = NominationVoteViewController(nibName: "NominationVoteView", bundle: NSBundle.mainBundle())
        vc.view.frame = self.playersCollectionView.frame
        self.addChildViewController(vc)
        vc.view.alpha = 0.0
        self.view.addSubview(vc.view)
        UIView.animateWithDuration(0.4,
          delay: 0.0,
          options: UIViewAnimationOptions.CurveEaseInOut,
          animations: { () -> Void in
            vc.view.alpha = 1.0
          },
          completion: { (success) -> Void in
            return () //Add more animation here if needed.
        })
        
      })
    }
  }

  func startMission() {
    println("GAME CONTROLLER : Start Mission Called")
    self.lastRejectedGameCount = 0
    
    self.animateIncomingMessageLabel("New Mission Proposed", completionHandler: { () -> (Void) in
      
      let vc = MissionTextViewController(nibName: "MissionTextViewController", bundle: NSBundle.mainBundle())
      vc.view.frame = self.playersCollectionView.frame
      self.incomingMesageLabel.text = "New Mission Proposed"
      self.addChildViewController(vc)
      vc.view.alpha = 0.0
      self.view.addSubview(vc.view)
      UIView.animateWithDuration(0.4,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          vc.view.alpha = 1.0
        },
        completion: { (success) -> Void in
          return () //Add more animation here if needed.
      })
    })
  }
  
  func voteOnMissionSuccess() {
    
    let game = gameController.game
    let currentMission = game.missions[game.currentMission] as Mission
    let nominatedPlayers = currentMission.nominatedPlayers
    let didVote = gameController.missionOutcomesVotedFor[gameController.game.currentMission]
    if didVote == false {
      
      self.animateIncomingMessageLabel("Mission Proceeding", completionHandler: { () -> (Void) in
        for player in nominatedPlayers {
          if player.peerID == self.gameController.thisPlayer.peerID {
            let vc = MissionOutcomeVoteViewController(nibName: "MissionOutcomeView", bundle: NSBundle.mainBundle())
            vc.game = game
            vc.currentUser = self.gameController.thisPlayer
            vc.view.frame = self.playersCollectionView.frame
            self.addChildViewController(vc)
            vc.view.alpha = 0.0
            self.view.addSubview(vc.view)
            UIView.animateWithDuration(0.4,
              delay: 0.0,
              options: UIViewAnimationOptions.CurveEaseInOut,
              animations: { () -> Void in
                vc.view.alpha = 1.0
              },
              completion: { (success) -> Void in
                return () //Add more animation here if needed.
            })
          } else {
            self.nominationPromptLabel.hidden = false
            self.nominationPromptLabel.text = "Mission is taking place..."
          }
        }
      })
    }
  }

  func revealMissionOutcome() {
    
    self.animateIncomingMessageLabel("Mission Completed", { () -> (Void) in
      let vc = RevealMissionOutcomeViewController(nibName: "RevealMissionOutcomeViewController", bundle: NSBundle.mainBundle())
      vc.view.frame = self.playersCollectionView.frame
      vc.view.alpha = 0.0
      self.addChildViewController(vc)
      self.view.addSubview(vc.view)
      
      UIView.animateWithDuration(0.4,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          vc.view.alpha = 1.0
        },
        completion: { (success) -> Void in
          let game = self.gameController.game
          let justCompletedMission = game.missions[game.currentMission-1] as Mission
          let justCompletedMissionIndex = game.currentMission-1
          let label = self.missionLabelArray[justCompletedMissionIndex]
          label.hidden = false
          if justCompletedMission.success == true {
            label.text = "\u{E11C}"
            label.textColor = UIColor.greenColor()
          } else {
            label.text = "\u{E11A}"
            label.textColor = UIColor.redColor()
          }
      })
    })
  }
  
  func processEndMission() {
    
    let game = gameController.game
    let currentMissionIndex = game.currentMission
    self.nominationPromptLabel.text = " "
    if currentMissionIndex == 5 || game.failedMissionCount == 3 || game.passedMissionCount == 3 {
      self.endGame()
    } else {
      self.startMission()
    }
  }
  
  func endGame(){
    let vc = EndGameViewController(nibName: "EndGameViewController", bundle: NSBundle.mainBundle())
    vc.view.frame = self.playersCollectionView.frame

    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.playersCollectionView.reloadData()
      self.addChildViewController(vc)
      self.view.addSubview(vc.view)
    }
  }
    
    func startBlinking (label: UILabel)
    {
        label.alpha = 1
        self.labelsAreBlinking = true
        
        var animationQueue = NSOperationQueue()
        animationQueue.maxConcurrentOperationCount = 1
        
        while self.labelsAreBlinking
        {
            UIView.animateWithDuration(1, animations:
            { () -> Void in
                    label.alpha = 0
            })
            UIView.animateWithDuration(1, animations:
            { () -> Void in
                    label.alpha = 1
            })
        }
        label.alpha = 1
    }
  
  func animateIncomingMessageLabel(incomingMessageText: String, completionHandler : () -> (Void)) {
    println("Animate Label Called!")
    
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.playersCollectionView.reloadData()
      self.incomingMesageLabel.text = incomingMessageText
      self.incomingMesageLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
      UIView.animateWithDuration(0.4,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.incomingMesageLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
          self.incomingMesageLabel.alpha = 1.0
        },
        completion: { (success) -> Void in
          UIView.animateWithDuration(0.4,
            delay: 1.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
              self.incomingMesageLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
              self.incomingMesageLabel.alpha = 0.0
            },
            completion: { (success) -> Void in
              completionHandler()
            })})}
  }
  
  @IBAction func gearButtonPressed(sender: AnyObject) {
    let screenshot = self.view.snapshotViewAfterScreenUpdates(true)
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      let settingsVC = HelpViewController(nibName:"HelpViewController", bundle: NSBundle.mainBundle())
      self.presentViewController(settingsVC, animated: true) { () -> Void in
        settingsVC.view.addSubview(screenshot)
        settingsVC.view.sendSubviewToBack(screenshot)
      }
    }
  }
  
  func countdownLabel() {
    nominationPromptLabel.hidden = false
    nominationPromptLabel.text = "----------"
    UIView.animateKeyframesWithDuration(10.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "---------"
      })
      UIView.addKeyframeWithRelativeStartTime(1.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "--------"
      })
      UIView.addKeyframeWithRelativeStartTime(2.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "-------"
      })
      UIView.addKeyframeWithRelativeStartTime(3.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "------"
      })
      UIView.addKeyframeWithRelativeStartTime(4.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "-----"
      })
      UIView.addKeyframeWithRelativeStartTime(5.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "----"
      })
      UIView.addKeyframeWithRelativeStartTime(6.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "---"
      })
      UIView.addKeyframeWithRelativeStartTime(7.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "--"
      })
      UIView.addKeyframeWithRelativeStartTime(8.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = "-"
      })
      UIView.addKeyframeWithRelativeStartTime(9.0, relativeDuration: 1.0, animations: { () -> Void in
        self.nominationPromptLabel.text = ""
      })
    }) { (success) -> Void in
      println("done")
    }
  }

}

