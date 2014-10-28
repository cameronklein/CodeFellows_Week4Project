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
    //var currentMission : Mission?
    //TODO: Figure out where to pull a user's vote status from.
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //round corners on players collection view
        self.playersCollectionView.layer.cornerRadius = self.playersCollectionView.frame.size.width / 16
        self.playersCollectionView.layer.masksToBounds = true
        //round corners on missions view
        self.missionView.layer.cornerRadius = self.missionView.frame.size.width / 32
        self.missionView.layer.masksToBounds = true
        
        self.backgroundImageView.animateGif("matrix_code1.gif", startAnimating: true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.players!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
        let player = self.players?[indexPath.row]

        cell.imageView.image = player?.playerImage
        cell.username.text = player?.playerName
        
        if player?.currentVote != nil
        {
            if (player?.currentVote == true)
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
    
    func voteOnProposedTeam(nominatedPlayers : [Player])
    {//Display the nominated team to all users and get a vote of Approve or Reject back
        let nominationVC = NominationVoteViewController(nibName: "NominationVoteView", bundle: NSBundle.mainBundle())
        let nominationView = nominationVC.view
        nominationVC.nominatedPlayersArray = nominatedPlayers
        nominationView.frame = self.view.frame
        self.addChildViewController(nominationVC)
        self.view.addSubview(nominationView)
    }

    //MARK: - One line, because we probably won't use this.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}