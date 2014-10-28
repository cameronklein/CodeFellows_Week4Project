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
    
    //var PlayersForGame = [PlayerForGame]?
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PLAYER", forIndexPath: indexPath) as PlayerCell
        
        return cell
    }

    //MARK: - One line, because we probably won't use this.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}