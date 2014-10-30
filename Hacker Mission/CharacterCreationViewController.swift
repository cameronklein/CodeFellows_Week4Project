//
//  CharacterCreationViewController.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/29/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

protocol CharacterCreationViewDelegate {
    func didSaveUser(userToSave: UserInfo)
}

class CharacterCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    //MARK: - Outlets and Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var defaultIconsCollectionView: UICollectionView!
    @IBOutlet weak var saveCharacterButton: UIButton!
    @IBOutlet weak var userImageView : UIImageView!

    var defaultIcons = [UIImage]()
    var userForSave : UserInfo!
    var userNameFor : NSString?
    var userImageFor : UIImage?
    var delegate : CharacterCreationViewDelegate?

    
    //MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if self.defaultIcons.count == 0 {
            let symbol1 = UIImage(named: "AsteriskSymbol")
            let symbol2 = UIImage(named: "DollarSymbol")
            let symbol3 = UIImage(named: "AmpersandSymbol")
            let symbol4 = UIImage(named: "PercentSymbol")
            let symbol5 = UIImage(named: "AtSymbol")
            let symbol6 = UIImage(named: "OctothorpeSymbol")
            let symbol7 = UIImage(named: "QuestionSymbol")
            let symbol8 = UIImage(named: "InfinitySymbol")

            self.defaultIcons.append(symbol1!)
            self.defaultIcons.append(symbol2!)
            self.defaultIcons.append(symbol3!)
            self.defaultIcons.append(symbol4!)
            self.defaultIcons.append(symbol5!)
            self.defaultIcons.append(symbol6!)
            self.defaultIcons.append(symbol7!)
            self.defaultIcons.append(symbol8!)
        }

        self.usernameTextField.delegate = self


    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)

        if self.userImageFor != nil && self.userNameFor != nil {
            self.saveCharacterButton.hidden = false
        } else {
            self.saveCharacterButton.hidden = true
        }
        
    }
    
    //MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = defaultIconsCollectionView.dequeueReusableCellWithReuseIdentifier("DEFAULT_ICON_CELL", forIndexPath: indexPath) as DefaultIconCell
        cell.imageView.image = self.defaultIcons[indexPath.row] as UIImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.userImageFor = self.defaultIcons[indexPath.row] as UIImage!
        self.userImageView.image = self.userImageFor

    }
    
    //MARK: - Actions and Outlets
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      var localUserInfo = UserInfo(userName: self.userNameFor!, userImage: self.userImageFor!)
      self.userForSave = localUserInfo
      self.delegate?.didSaveUser(self.userForSave)
      if let pathForSave = appDelegate.documentsPath as String! {
        println("Can Save File")
      } else {
        println("ERROR: No save path found, this is a fail case.")
      }

    }

    @IBAction func photoButtonPressed(sender: AnyObject) {
        let alertViewController = UIAlertController(title: "Image", message: "Use a photo for your player icon", preferredStyle: UIAlertControllerStyle.ActionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            println("Cancel")
        }
        let takePictureAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imageTaker = UIImagePickerController()
            imageTaker.allowsEditing = true
            imageTaker.sourceType = UIImagePickerControllerSourceType.Camera
            imageTaker.delegate = self
            self.presentViewController(imageTaker, animated: true, completion: nil)
        }
        let selectPictureAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imageSelector = UIImagePickerController()
            imageSelector.allowsEditing = true
            imageSelector.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imageSelector.delegate = self
            self.presentViewController(imageSelector, animated: true, completion: nil)
        }

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            alertViewController.addAction(takePictureAction)
        }
        alertViewController.addAction(selectPictureAction)
        alertViewController.addAction(cancelAction)

        self.presentViewController(alertViewController, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.userImageView.image = info[UIImagePickerControllerEditedImage] as UIImage!
        self.userImageFor = self.userImageView.image as UIImage!
        self.dismissViewControllerAnimated(true, completion: nil)

        if self.userImageFor != nil && self.userNameFor != nil {
            self.saveCharacterButton.hidden = false
        }

    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if countElements(textField.text) > 0 {
            return true
        } else {
            return false
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        self.userForSave?.userName = textField.text!

        if self.userImageFor != nil && self.userNameFor != nil {
            self.saveCharacterButton.hidden = false
        }

    }



    //MARK: - You probably won't need this stupid thing.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}