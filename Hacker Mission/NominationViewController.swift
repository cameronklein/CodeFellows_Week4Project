//
//  CharacterRevealController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class NominationVoteViewController: UIViewController, UICollectionViewDataSource
{
  @IBOutlet weak var nominatedPlayerViewContoller : UICollectionView!
  @IBOutlet weak var collectionView: UICollectionView!

  var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
  var game : GameSession!
  var nominatedPlayersArray : [Player] = [Player]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    self.collectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let currentMission = game.missions[game.currentMission] as Mission
    nominatedPlayersArray = currentMission.nominatedPlayers
    collectionView.reloadData()
  }
  
  @IBAction func approveNominatedTeam (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : "Approve"])
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  @IBAction func rejectNominatedTeam (sender: AnyObject)
  {
    multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : "Reject"])
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
    let player = nominatedPlayersArray[indexPath.row] as Player
    
    cell.imageView.image = player.playerImage
    cell.username.text = player.playerName
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return nominatedPlayersArray.count
  }
    
    
}
