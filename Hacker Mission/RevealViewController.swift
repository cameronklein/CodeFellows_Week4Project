//
//  RevealViewController.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/29/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    //MARK: - Outlets and Properties
    @IBOutlet weak var playerRevealCollectionView: UICollectionView!
    @IBOutlet weak var flavorTextLabel: UILabel!
    
    var playerArray = [Player]()
    var agentArray = [Player]()
    var imagePacketArray = [ImagePacket]()
    var gameController = GameController.sharedInstance
    var screenWidth : CGFloat!
    var layout : UICollectionViewFlowLayout!
    var homeVC : HomeViewController!
  
    //MARK: - View Methods
    
    override func viewDidLoad(){
      
      //gameController.sendUserInfo()
      
      super.viewDidLoad()
      self.playerRevealCollectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
      self.playerRevealCollectionView.delegate = self
      self.playerRevealCollectionView.dataSource = self
    
      self.layout = playerRevealCollectionView.collectionViewLayout as UICollectionViewFlowLayout
      self.screenWidth = self.playerRevealCollectionView.frame.width
      super.viewWillAppear(true)
      layout.minimumLineSpacing = screenWidth * 0.02
      layout.minimumInteritemSpacing = screenWidth * 0.02
      layout.sectionInset.left = screenWidth * 0.05
      layout.sectionInset.right = screenWidth * 0.05
      layout.itemSize = CGSize(width: screenWidth * 0.17, height: screenWidth * 0.23)
      
      
      
      for player in gameController.game.players {
        playerArray.append(player as Player)
      }

        for player in self.playerArray
        {
            if (player.playerRole == .Agent)
            {
                self.agentArray.append(player)
            }
        }
        
        if gameController.thisPlayer.playerRole == .Agent
        {
          self.flavorTextLabel.typeToNewString("You you have successfully infiltrated the Opposition hacker collective. Work with your fellow agents and protect the regime and the status quo.", withInterval: 0.1)
        }
        else
        {
          self.flavorTextLabel.typeToNewString("You are a hacker for the Opposition, working to end the oppressive Government regime. Be wary of Goivernment agents who have infiltrated the collective.", withInterval: 0.1)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if gameController.thisPlayer.playerRole == .Agent {
            return self.agentArray.count
        } else {
            return self.playerArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = playerRevealCollectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
        
        var player : Player?
        var imageFor = self.findMatchingImageForPlayer(player!, imagePacketArray: self.gameController.imagePackets)

        if gameController.thisPlayer.playerRole == .Agent {
            player = agentArray[indexPath.row]
        } else {
            player = playerArray[indexPath.row]
        }
        
        cell.imageView.image = imageFor as UIImage
        cell.username.text = player?.playerName
        
        return cell
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
    
    //MARK: Actions and other functions
    @IBAction func confirmationButtonPressed(sender: AnyObject)
    {
        UIView.animateWithDuration(0.3, animations:
        { () -> Void in
            self.view.alpha = 0
        })
//        self.view.removeFromSuperview()
//        self.removeFromParentViewController()
          let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
          let homeVC = storyboard.instantiateViewControllerWithIdentifier("HOME") as HomeViewController
  
          NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
          self.presentViewController(homeVC, animated: true, completion: { () -> Void in
            homeVC.startMission()
            return ()
          })
       //   self.dismissViewControllerAnimated(false, completion: { () -> Void in})

        } }

    //MARK: - You probably won't need this stupid thing.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}