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
    
    var players : [Player] = []
    var user : Player?
    var playersSelected = 0
    var game : GameSession!
    var labelsAreBlinking = false
    
    var screenWidth : CGFloat!
    var layout : UICollectionViewFlowLayout!
    var multiPeerController = MultiPeerController.sharedInstance
    //var gameController = GameController.sharedInstance
    
    var selectedIndexPath : NSIndexPath?
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.playersCollectionView.delegate = self
        self.playersCollectionView.dataSource = self
        self.playersCollectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
        
        //Set Cell Dimensions
        self.layout = playersCollectionView.collectionViewLayout as UICollectionViewFlowLayout
        self.screenWidth = self.playersCollectionView.frame.width
        super.viewWillAppear(true)
        layout.minimumLineSpacing = screenWidth * 0.02
        layout.minimumInteritemSpacing = screenWidth * 0.02
        layout.sectionInset.left = screenWidth * 0.05
        layout.sectionInset.right = screenWidth * 0.05
        layout.itemSize = CGSize(width: screenWidth * 0.17, height: screenWidth * 0.17)
        
        //round corners on players collection view
        self.playersCollectionView.layer.cornerRadius = self.playersCollectionView.frame.size.width / 16
        self.playersCollectionView.layer.masksToBounds = true
        //round corners on missions view
        self.missionView.layer.cornerRadius = self.missionView.frame.size.width / 32
        self.missionView.layer.masksToBounds = true
        
       // self.backgroundImageView.animateGif("matrix_code1.gif", startAnimating: true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - Collection view methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      println("CollectionView asking for cells. Returned \(game.players.count).")
        return self.game.players.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
      let player = self.game.players[indexPath.row] as Player

      cell.imageView.image = player.playerImage
      cell.username.text = player.playerName
      
      if player.isNominated
      {
          cell.layer.borderColor = UIColor.greenColor().CGColor
          cell.layer.borderWidth = 1
      }
      else
      {
          cell.layer.borderColor = UIColor.blackColor().CGColor
          cell.layer.borderWidth = 0
      }
      
      if self.game.currentGameState == .NominatePlayers
      {
        cell.approvesMission.hidden = true
        cell.rejectsMission.hidden = true
      }
      
      if player.currentVote != nil
      {
      
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
          cell.rejectsMission.hidden = true
          cell.approvesMission.hidden = true
      }
      
      if player.isLeader == true {
        cell.leaderStar.hidden = false
      } else if player.isLeader == false {
        cell.leaderStar.hidden = true
      }
      
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var player = game.players[indexPath.row]
        
        if player.isNominated == true
        {
            player.isNominated = false
            self.playersSelected -= 1
            self.playersCollectionView.reloadData()
        }
        else
        {
          if self.playersSelected == (game.missions[game.currentMission] as Mission).playersNeeded
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
        
        
        if self.playersSelected == (game.missions[game.currentMission] as Mission).playersNeeded
        {
            self.confirmNominationButton.userInteractionEnabled = true
            UIView.animateWithDuration(0.1, animations:
            { () -> Void in
                self.confirmNominationButton.titleLabel?.textColor = UIColor.greenColor()
                return ()
            })
            
        }
    }
    
    //MARK: - Actions and other functions
  
    func nominatePlayers(game : GameSession)
    {
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        if self.user?.isLeader == true
        {
            self.nominationPromptLabel.hidden = false
            self.nominationPromptLabel.text = "Nominate team members."
          //self.startBlinking(self.nominationPromptLabel)
            self.nominationPromptLabel.text = "Nominate \((game.missions[game.currentMission] as Mission).playersNeeded) agents to send on this mission."
            self.confirmNominationButton.hidden = false
            self.confirmNominationButton.userInteractionEnabled = false
            self.playersCollectionView.userInteractionEnabled = true
        }
        else
        {
            self.nominationPromptLabel.hidden = false
            self.nominationPromptLabel.text = "Nominations being selected..."
          //self.startBlinking(self.nominationPromptLabel)
        }
      }
    }
    
    @IBAction func confirmNominations(sender: AnyObject)
    {
      println("Confirmed Button Pressed")
        self.playersCollectionView.userInteractionEnabled = false
        self.confirmNominationButton.userInteractionEnabled = false
        self.confirmNominationButton.titleLabel?.textColor = UIColor.grayColor()
        self.labelsAreBlinking = false
        self.nominationPromptLabel.hidden = true
        self.confirmNominationButton.hidden = true
      
      
        var nominatedPlayerIDs = [String]()
        for player in game.players {
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
  
  func voteOnProposedTeam(game: GameSession)
  {//Display the nominated team to all users and get a vote of Approve or Reject back
    self.labelsAreBlinking = false
    self.nominationPromptLabel.hidden = true
    
    let vc = NominationVoteViewController(nibName: "NominationVoteView", bundle: NSBundle.mainBundle())
    vc.game = game
    vc.view.frame = self.playersCollectionView.frame
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.addChildViewController(vc)
      self.view.addSubview(vc.view)
    }
  }
//
//  func revealVotes(game : GameSession) {
//   self.playersCollectionView.reloadData()
//  }
//
  func startMission(game : GameSession) {
    let vc = MissionTextViewController(nibName: "MissionTextViewController", bundle: NSBundle.mainBundle())
    vc.view.frame = self.playersCollectionView.frame
    vc.game = game
    if user!.isLeader == true {
      vc.leaderSelectingTeam.text = "You are the leader. Select your team wisely"
    }
    self.incomingMesageLabel.text = "New Mission Proposed"
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
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
            delay: 0.9,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
              self.incomingMesageLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
              self.incomingMesageLabel.alpha = 0.0
            },
            completion: { (success) -> Void in
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
      })
      
    }
  }
  
  func voteOnMissionSuccess(game: GameSession) {
    
    
    let currentMission = game.missions[game.currentMission] as Mission
    let nominatedPlayers = currentMission.nominatedPlayers
    
    for player in nominatedPlayers {
      println("Comparing \(player.peerID) and \(user!.peerID)")
      if player.peerID == user!.peerID {
        let vc = MissionOutcomeVoteViewController(nibName: "MissionOutcomeView", bundle: NSBundle.mainBundle())
        vc.game = game
        vc.currentUser = self.user
        vc.view.frame = self.playersCollectionView.frame
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
          println("Presenting Mission Vote Screen!")
          self.addChildViewController(vc)
          self.view.addSubview(vc.view)
        }
      } else {
        self.nominationPromptLabel.hidden = false
        self.nominationPromptLabel.text = "Mission is taking place..."
      }
    }
  }

  func revealMissionOutcome(game : GameSession) {
    
    let vc = RevealMissionOutcomeViewController(nibName: "RevealMissionOutcomeViewController", bundle: NSBundle.mainBundle())
    vc.view.frame = self.playersCollectionView.frame
    vc.game = game
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.addChildViewController(vc)
      self.view.addSubview(vc.view)
        let justCompletedMission = game.missions[game.currentMission-1] as Mission
        let justCompletedMissionIndex = game.currentMission-1
        if justCompletedMission.success == true
        {
            switch justCompletedMissionIndex {
            case 0:
                self.mission1OutcomeLabel.text = "\u{E11C}"
                self.mission1OutcomeLabel.textColor = UIColor.greenColor()
            case 1:
                self.mission2OutcomeLabel.text = "\u{E11C}"
                self.mission2OutcomeLabel.textColor = UIColor.greenColor()
            case 2:
                self.mission3OutcomeLabel.text = "\u{E11C}"
                self.mission3OutcomeLabel.textColor = UIColor.greenColor()
            case 3:
                self.mission4OutcomeLabel.text = "\u{E11C}"
                self.mission4OutcomeLabel.textColor = UIColor.greenColor()
            case 4:
                self.mission5OutcomeLabel.text = "\u{E11C}"
                self.mission5OutcomeLabel.textColor = UIColor.greenColor()
            default:
                println("You should never see this.")
            }
        }
        else
        {
            switch justCompletedMissionIndex {
            case 0:
                self.mission1OutcomeLabel.text = "\u{E11A}"
                self.mission1OutcomeLabel.textColor = UIColor.redColor()
            case 1:
                self.mission2OutcomeLabel.text = "\u{E11A}"
                self.mission2OutcomeLabel.textColor = UIColor.redColor()
            case 2:
                self.mission3OutcomeLabel.text = "\u{E11A}"
                self.mission3OutcomeLabel.textColor = UIColor.redColor()
            case 3:
                self.mission4OutcomeLabel.text = "\u{E11A}"
                self.mission4OutcomeLabel.textColor = UIColor.redColor()
            case 4:
                self.mission5OutcomeLabel.text = "\u{E11A}"
                self.mission5OutcomeLabel.textColor = UIColor.redColor()
            default:
                println("You should never see this.")
            }
        }
    }
  }
  
  func processEndMission() {
    
    let currentMissionIndex = game.currentMission
    if currentMissionIndex == 5 || game.failedMissionCount == 3 || game.passedMissionCount == 3 {
      self.endGame()
    } else {
      self.startMission(game)
    }
    
    
    
  }
  
  func endGame(){
    let vc = EndGameViewController(nibName: "EndGameViewController", bundle: NSBundle.mainBundle())
    vc.view.frame = self.playersCollectionView.frame
    vc.game = game

    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
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

    //MARK: - One line, because we probably won't use this.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}