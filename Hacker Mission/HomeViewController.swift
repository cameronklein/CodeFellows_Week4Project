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
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var playersCollectionView: UICollectionView!
    @IBOutlet weak var mission1ImageView: UIImageView!
    @IBOutlet weak var mission1To2TransitionImageView: NSLayoutConstraint!
    @IBOutlet weak var mission2ImageView: UIImageView!
    @IBOutlet weak var mission2To3TransitionImageView: UIImageView!
    @IBOutlet weak var mission3ImageView: UIImageView!
    @IBOutlet weak var mission3To4TransitionImageView: UIImageView!
    @IBOutlet weak var mission4ImageView: UIImageView!
    @IBOutlet weak var mission4To5TransitionImageView: UIImageView!
    @IBOutlet weak var mission5ImageView: UIImageView!
    @IBOutlet weak var missionView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var votingResultsIndicatorLabel: UILabel!
    @IBOutlet weak var nominationPromptLabel: UILabel!
    @IBOutlet weak var confirmNominationButton: UIButton!
    
    var players : [Player] = []
    var user : Player?
    var playersSelected = 0
    var game : GameSession!
    //var gameController = GameController.sharedInstance
    
    var selectedIndexPath : NSIndexPath?
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.playersCollectionView.delegate = self
        self.playersCollectionView.dataSource = self
        self.playersCollectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
        
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
            player.isNominated = true
            self.playersSelected += 1
            self.playersCollectionView.reloadData()
        }
        
        
        if self.playersSelected == (game.missions[game.currentMission] as Mission).playersNeeded
        {
            self.playersCollectionView.userInteractionEnabled = false
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
        if self.user?.isLeader == true
        {
            self.nominationPromptLabel.hidden = false
            self.nominationPromptLabel.text = "Nominate \((game.missions[game.currentMission] as Mission).playersNeeded) agents to send on this mission."
            self.confirmNominationButton.hidden = false
            self.confirmNominationButton.userInteractionEnabled = false
            self.playersCollectionView.userInteractionEnabled = true
            
        }
        else
        {
            self.nominationPromptLabel.hidden = false
            self.nominationPromptLabel.text = "Nominations being selected..."
        }
    }
    
    @IBAction func confirmNominations(sender: AnyObject)
    {
        self.confirmNominationButton.userInteractionEnabled = false
        self.confirmNominationButton.titleLabel?.textColor = UIColor.grayColor()
        self.confirmNominationButton.hidden = true
        
        //dself.gameController.sendInfoToMainBrain()
    }
  
  func voteOnProposedTeam(game: GameSession)
  {//Display the nominated team to all users and get a vote of Approve or Reject back
    let vc = NominationVoteViewController(nibName: "NominationVoteView", bundle: NSBundle.mainBundle())
    vc.game = game
    vc.view.frame = self.playersCollectionView.frame
    self.addChildViewController(vc)
    self.view.addSubview(vc.view)
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
    self.addChildViewController(vc)
    self.view.addSubview(vc.view)
  }
  
  func voteOnMissionSuccess(game: GameSession) {
    
    let currentMission = game.missions[game.currentMission] as Mission
    let nominatedPlayers = currentMission.nominatedPlayers

    for player in nominatedPlayers {
      let castedPlayer = player as? Player
      if castedPlayer!.peerID == user!.peerID {
        let vc = MissionOutcomeVoteViewController(nibName: "MissionOutcomeView", bundle: NSBundle.mainBundle())
        vc.view.frame = self.view.frame
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
      } else {
        self.nominationPromptLabel.hidden = false
        self.nominationPromptLabel.text = "Mission is taking place..."
      }
    }
  }

  func revealMissionOutcome(game : GameSession) {
    
    let vc = RevealMissionOutcomeViewController(nibName: "RevealView", bundle: NSBundle.mainBundle())
    vc.view.frame = self.view.frame
    vc.game = game
    self.addChildViewController(vc)
    self.view.addSubview(vc.view)
    
  }

    //MARK: - One line, because we probably won't use this.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}