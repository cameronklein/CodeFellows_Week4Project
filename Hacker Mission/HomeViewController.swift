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