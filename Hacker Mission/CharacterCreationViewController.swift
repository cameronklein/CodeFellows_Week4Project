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
      self.defaultIconsCollectionView.dataSource = self
      self.defaultIconsCollectionView.delegate = self

      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      if let filePath = appDelegate.documentsPath as String! {
        println("found path")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
          self.loadIt()
        }
      }

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)



      self.userImageView.image = self.userImageFor



        self.checkButtonState()
        
    }
    
    //MARK: - Collection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.defaultIcons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = defaultIconsCollectionView.dequeueReusableCellWithReuseIdentifier("DEFAULT_ICON_CELL", forIndexPath: indexPath) as DefaultIconCell
        cell.imageView.image = self.defaultIcons[indexPath.row] as UIImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
      self.checkFirstResponder()
      self.userImageFor = self.defaultIcons[indexPath.row] as UIImage!
      self.userImageView.image = self.userImageFor

      checkButtonState()

    }



    //MARK: - Actions and Outlets
  func checkNameLength() -> Bool {
    if self.userNameFor != nil && countElements(self.usernameTextField.text) > 0 {
      return true
    } else {
      return false
    }
  }


    func checkButtonState(){
        println("Checked Button State")
        if self.userImageFor != nil && self.checkNameLength() == true {
            self.saveCharacterButton.enabled = true
            self.saveCharacterButton.setTitle("Save Character", forState: UIControlState.Normal)
//            self.saveCharacterButton.titleLabel?.typingAnimation(0.1)
        } else {
            println("Hit Else")
            self.saveCharacterButton.setTitle("Enter a Player Name and Choose an Image", forState: UIControlState.Disabled)
            self.saveCharacterButton.enabled = false
        }
    }
    
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      var localUserInfo = UserInfo(userName: self.userNameFor!, userImage: self.userImageFor!)
      self.userForSave = localUserInfo
      self.delegate?.didSaveUser(self.userForSave)
      if let pathForSave = appDelegate.documentsPath as String! {
      println("Can Save File")
        UserInfo.saveTheObject(localUserInfo)
        appDelegate.defaultUser = localUserInfo
        self.dismissViewControllerAnimated(true, completion: nil)
      } else {
        println("ERROR: No save path found, this is a fail case.")
      }

    }

  func loadIt() {
    var object = UserInfo.loadTheObject()
    let userForLoad = object
    println("userName is \(userForLoad.userName)")
    self.userImageView.image = userForLoad.userImage as UIImage!
    self.usernameTextField.text = userForLoad.userName
    self.userNameFor = userForLoad.userName
    self.userImageFor = userForLoad.userImage
    println("is the \(userForLoad.userImage)")

  }


  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)

      self.checkFirstResponder()


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
      var imageToResize = info[UIImagePickerControllerEditedImage] as UIImage!
      let size = CGSize(width: 350, height: 350)
      UIGraphicsBeginImageContext(size)
        imageToResize.drawInRect(CGRect(x: 0, y: 0, width: 350, height: 350))
        var imageResized = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      self.userImageView.image = imageResized
        self.userImageFor = imageResized as UIImage!
        self.dismissViewControllerAnimated(true, completion: nil)


        checkButtonState()

    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if countElements(textField.text) > 0 {
          println("is text")
          checkButtonState()
            return true
        } else {
            println("no text")
          checkButtonState()
            return false
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {

        println("didEndEditing")
      if countElements(textField.text) > 0 {
        self.userNameFor = textField.text!
      } else {
        self.userNameFor = nil
      }

        checkButtonState()
    }

  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    println("editing in \(textField)")
    return true
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if countElements(textField.text) > 0 {
      textField.resignFirstResponder()
      return true
    } else {
      return false
    }

  }

//  func textFieldShouldClear(textField: UITextField) -> Bool {
//    if countElements(textField.text) == 1 {
//      self.userNameFor = nil
//    }
//
//    return true
//  }

  func checkFirstResponder() {
    if self.usernameTextField.isFirstResponder() {
      let trueFalse = self.textFieldShouldEndEditing(self.usernameTextField) as Bool!
      if trueFalse == true {
        self.userNameFor = nil
        self.usernameTextField.resignFirstResponder()
      }
      self.checkButtonState()
      self.usernameTextField.resignFirstResponder()
    }
  }



    //MARK: - You probably won't need this stupid thing.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}