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
  @IBOutlet weak var approveButton: UIButton!
  @IBOutlet weak var rejectButton: UIButton!

  var multiPeerController : MultiPeerController = MultiPeerController.sharedInstance
  var gameController = GameController.sharedInstance
  var nominatedPlayersArray = [Player]()
  var currentMission : Mission!
  var logFor = LogClass()


  var screenWidth : CGFloat!
  var layout : UICollectionViewFlowLayout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    self.collectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
    self.layout = nominatedPlayerViewContoller.collectionViewLayout as UICollectionViewFlowLayout
    self.screenWidth = self.nominatedPlayerViewContoller.frame.width
    super.viewWillAppear(true)
//    layout.minimumLineSpacing = screenWidth * 0.02
    layout.minimumInteritemSpacing = screenWidth * 0.01
//    layout.sectionInset.left = screenWidth * 0.05
//    layout.sectionInset.right = screenWidth * 0.05
    layout.itemSize = CGSize(width: screenWidth * 0.16, height: screenWidth * 0.186)

    currentMission = gameController.game.missions[gameController.game.currentMission] as Mission
    logFor.DLog("Nomination View Controller got an array: \(currentMission.nominatedPlayers.description)")
    nominatedPlayersArray = currentMission.nominatedPlayers
    collectionView.reloadData()
    self.approveButton.userInteractionEnabled = true
    self.rejectButton.userInteractionEnabled = true
    approveButton.addBorder()
    rejectButton.addBorder()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(animated: Bool) {
    self.view.layer.cornerRadius = self.view.frame.size.width / 16
    self.view.layer.masksToBounds = true
  }
  
  @IBAction func approveNominatedTeam (sender: AnyObject)
  {
    gameController.teamsVotedFor[gameController.game.currentMission][currentMission.rejectedTeamsCount] = true
    multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : "Approve"])
    self.approveButton.userInteractionEnabled = false
    self.rejectButton.userInteractionEnabled = false
    let parentVC = self.parentViewController as HomeViewController
    parentVC.nominationPromptLabel.text = "Waiting on other players..."
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  @IBAction func rejectNominatedTeam (sender: AnyObject)
  {
    gameController.teamsVotedFor[gameController.game.currentMission][currentMission.rejectedTeamsCount] = true
    multiPeerController.sendInfoToMainBrain(["action" : "vote", "value" : "Reject"])
    self.approveButton.userInteractionEnabled = false
    self.rejectButton.userInteractionEnabled = false
    let parentVC = self.parentViewController as HomeViewController
    parentVC.nominationPromptLabel.text = "Waiting on other players..."
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
    let player = nominatedPlayersArray[indexPath.row] as Player
    
    logFor.DLog("NOMINATION VOTE VIEW CONTROLLER: Made cell for player,  \(player.playerName)")
    
    let imagePacketImage = self.findMatchingImageForPlayer(player, imagePacketArray: self.gameController.imagePackets)

    cell.imageView.image = imagePacketImage as UIImage!
    cell.username.text = player.playerName
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    logFor.DLog("NOMINATION VOTE VIEW CONTROLLER: Asking for cells, got \(nominatedPlayersArray.count)")
    return nominatedPlayersArray.count
    
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
}
