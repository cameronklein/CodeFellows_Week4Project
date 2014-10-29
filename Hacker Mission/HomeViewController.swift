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
    
    var players : [Player]?
    var user : Player?
    var game: GameSession!
    //var currentMission : Mission?
    //TODO: Figure out where to pull a user's vote status from.
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      println("CollectionView asking for cells. Returned \(self.players!.count).")
        return self.game.players.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
        let player = self.game.players[indexPath.row] as Player

        cell.imageView.image = player.playerImage
        cell.username.text = player.playerName
        
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
  

  
//  func nominatePlayers(game : GameSession) {
//    let vc = NominationViewController(nibName: "NominationView", bundle: NSBundle.mainBundle())
//    vc.view.frame = self.view.frame
//    self.addChildViewController(vc)
//    self.view.addSubview(vc.view)
//  }
//  
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
//  func startMission(game : GameSession) {
//    let vc = MissionStartViewController(nibName: "MissionStartView", bundle: NSBundle.mainBundle())
//    vc.view.frame = self.view.frame
//    self.addChildViewController(vc)
//    self.view.addSubview(vc.view)
//  }
//  
//  func voteOnMissionSuccess(game: GameSession) {
//    let vc = MissionVoteViewController(nibName: "MissionOutcomeView", bundle: NSBundle.mainBundle())
//    vc.view.frame = self.view.frame
//    self.addChildViewController(vc)
//    self.view.addSubview(vc.view)
//  }
//
//  func revealMissionOutcome(game : GameSession) {
//    let vc = RevealViewController(nibName: "RevealView", bundle: NSBundle.mainBundle())
//    vc.view.frame = self.view.frame
//    self.addChildViewController(vc)
//    self.view.addSubview(vc.view)
//  }

    //MARK: - One line, because we probably won't use this.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}