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
    
    var game : GameSession!
    var playerArray = [Player]()
    var agentArray = [Player]()
    var user : Player?
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.playerRevealCollectionView.registerNib(UINib(nibName: "PlayerCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "PLAYER")
        self.playerRevealCollectionView.delegate = self
        self.playerRevealCollectionView.dataSource = self
      
      for player in game.players {
        playerArray.append(player as Player)
      }
        //self.playerArray = game.players as [Player]
        
        //creates array of "agents"
        for player in self.playerArray
        {
            if (player.playerRole == .Agent)
            {
                self.agentArray.append(player)
            }
        }
        
        if user!.playerRole == .Agent
        {
            self.flavorTextLabel.text = "You're a secret bad guy. Here is your secret bad guy team."
            self.flavorTextLabel.typingAnimation(0.1)
        }
        else
        {
            self.flavorTextLabel.text = "You're a good guy. Some of your teammates are secret bad guys."
            self.flavorTextLabel.typingAnimation(0.1)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if user!.playerRole == .Agent
        {
            return self.agentArray.count
        }
        else
        {
            return self.playerArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = playerRevealCollectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
        
        var player : Player?
        
        if user!.playerRole == .Agent
        {
            player = agentArray[indexPath.row]
        }
        else
        {
            player = playerArray[indexPath.row]
        }
        
        cell.imageView.image = player?.playerImage
        cell.username.text = player?.playerName
        
        return cell
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
        let homeVC = UIStoryboard(name: "Main", bundle:
        NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("HOME") as HomeViewController
        homeVC.user = self.user
        homeVC.game = self.game
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(homeVC, animated: true, completion: nil)
       // self.dismissViewControllerAnimated(false, completion: { () -> Void in})

        } }

    //MARK: - You probably won't need this stupid thing.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}