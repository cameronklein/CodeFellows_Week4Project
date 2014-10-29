//
//  CharacterCreationViewController.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/29/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class CharacterCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    //MARK: - Outlets and Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var defaultIconsCollectionView: UICollectionView!
    @IBOutlet weak var saveCharacterButton: UIButton!
    
    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = defaultIconsCollectionView.dequeueReusableCellWithReuseIdentifier("DEFAULT_ICON_CELL", forIndexPath: indexPath) as UICollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    //MARK: - Actions and Outlets
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        
    }

    //MARK: - You probably won't need this stupid thing.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}