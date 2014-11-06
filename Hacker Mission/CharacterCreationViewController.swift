//
//  CharacterCreationViewController.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/29/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import QuartzCore

class CharacterCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    //MARK: - Outlets and Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var defaultIconsCollectionView: UICollectionView!
    @IBOutlet weak var saveCharacterButton: UIButton!
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

  let buttonBackgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.15)
  let cornerRadius = CGFloat(5.0)
  let outlineColor1 = UIColor(red: 0.443, green: 0.961, blue: 0.082, alpha: 0.2).CGColor
  let outlineColor2 = UIColor(red: 0.443, green: 0.961, blue: 0.082, alpha: 0.6).CGColor
  var shouldAnimate = false

    let attibutedString1 = NSAttributedString(string: "Enter a User Name", attributes: [NSForegroundColorAttributeName : UIColor(red: 0.486, green: 0.988, blue: 0.000, alpha: 0.75)])
    let attibutedString2 = NSAttributedString(string: "Enter a User Name", attributes: [NSForegroundColorAttributeName : UIColor(red: 0.486, green: 0.988, blue: 0.000, alpha: 0.15)])

    var defaultIcons = [UIImage]()
    var userForSave : UserInfo!
    var userNameFor : NSString?
    var userImageFor : UIImage?
    var hasLaunched = false
    var wasPresented = false

    
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

      self.cameraButton.backgroundColor = self.buttonBackgroundColor
      self.cameraButton.layer.masksToBounds = true
      self.cameraButton.layer.cornerRadius = self.cornerRadius
      self.cameraButton.layer.borderWidth = 2.0
      self.cameraButton.layer.borderColor = self.outlineColor1



      self.usernameTextField.delegate = self
      self.defaultIconsCollectionView.dataSource = self
      self.defaultIconsCollectionView.delegate = self

      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      if let filePath = appDelegate.documentsPath as String! {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
          self.loadIt()
        }
      }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

      self.userImageView.image = self.userImageFor
      self.checkButtonState()


      self.usernameTextField.attributedPlaceholder = attibutedString1

    }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.shouldAnimate = true
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    if appDelegate.defaultUser == nil {
      if self.hasLaunched == false {
        self.hasLaunched = true
        self.informThePlayer()
      } else {
        println("Has launched previously, don't alert the player that they need to save.")
      }
    }

    var layers = [CALayer]()
    layers.append(self.cameraButton.layer)

    self.doButtonPulseAnim(layers)

  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.shouldAnimate = false
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
      cell.layer.borderWidth = 2.0
      cell.layer.borderColor = outlineColor1

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

  func doButtonPulseAnim(layers: [CALayer]) {
    if self.shouldAnimate {
      let theAnimation = CABasicAnimation(keyPath: "borderColor")
      theAnimation.delegate = self

      println("here in core animation")
      theAnimation.repeatCount = 10000.0
      theAnimation.autoreverses = true
      theAnimation.fromValue = self.outlineColor1
      theAnimation.toValue = self.outlineColor2
      for layer in layers {
        theAnimation.duration = 1.0
        layer.addAnimation(theAnimation, forKey: "borderColor")
        layer.borderColor = outlineColor2
      }
    }
  }

  func doButtonPulseAnimAlso(layers: [CALayer]) {
    if self.shouldAnimate {
      let theAnimation = CABasicAnimation(keyPath: "borderColor")
      theAnimation.delegate = self

      println("here in core animation")
      theAnimation.repeatCount = 10000.0
      theAnimation.autoreverses = true
      theAnimation.fromValue = self.outlineColor1
      theAnimation.toValue = self.outlineColor2
      for layer in layers {
        theAnimation.duration = 1.0
        layer.addAnimation(theAnimation, forKey: "borderColor")
        layer.borderColor = outlineColor2
      }
    }
  }

    func checkButtonState(){
        println("Checked Button State")
        if self.userImageFor != nil && self.checkNameLength() == true {
            self.saveCharacterButton.enabled = true
            self.saveCharacterButton.setTitle("Save Character", forState: UIControlState.Normal)
          self.saveCharacterButton.backgroundColor = self.buttonBackgroundColor
          self.saveCharacterButton.layer.masksToBounds = true
          self.saveCharacterButton.layer.cornerRadius = self.cornerRadius
          self.saveCharacterButton.layer.borderWidth = 2.0
          self.saveCharacterButton.layer.borderColor = self.outlineColor1
          var layers = [CALayer]()
          layers.append(self.saveCharacterButton.layer)
          self.doButtonPulseAnimAlso(layers)
        } else {
            println("Hit Else")
            self.saveCharacterButton.setTitle("Enter Name and Choose an Image", forState: UIControlState.Disabled)
            self.saveCharacterButton.enabled = false
          self.saveCharacterButton.backgroundColor = UIColor.clearColor()
          self.saveCharacterButton.layer.masksToBounds = false
          self.saveCharacterButton.layer.cornerRadius = self.cornerRadius
          self.saveCharacterButton.layer.borderWidth = 0.0
          self.saveCharacterButton.layer.borderColor = UIColor.clearColor().CGColor
        }
    }
    
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      var localUserInfo = UserInfo(userName: self.userNameFor!, userImage: self.userImageFor!)
      self.userForSave = localUserInfo
      print("delegate is: ")
      if let pathForSave = appDelegate.documentsPath as String! {
      println("Can Save File")
        UserInfo.saveTheObject(localUserInfo)
        appDelegate.defaultUser = localUserInfo
        println("appdelegate user is \(appDelegate.defaultUser?.userName)")
        if wasPresented == true {
        self.dismissViewControllerAnimated(true, completion: nil)
        } else {
          let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
          let launchVC = storyboard.instantiateViewControllerWithIdentifier("LAUNCHVIEW_VC") as LaunchViewController
          launchVC.view.alpha = 0.0
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.presentViewController(launchVC, animated: true, completion: { () -> Void in
              UIView.animateWithDuration(1.0, animations: { () -> Void in
                launchVC.view.alpha = 1.0
              })
            })
          })
        }
        
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
          println("photobuttonpressed 1")
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
          println("photobuttonpressed 2")

      if let popoverController = alertViewController.popoverPresentationController {
        popoverController.sourceView = sender as UIView
        popoverController.sourceRect = sender.bounds
      }

        self.presentViewController(alertViewController, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      var imageToResize = info[UIImagePickerControllerEditedImage] as UIImage!
      let size = CGSize(width: 128, height: 128)
      UIGraphicsBeginImageContext(size)
        imageToResize.drawInRect(CGRect(x: 0, y: 0, width: 128, height: 128))
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
            return true
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
    if string == "" && range.location == 0 {
      self.userNameFor = nil
      checkButtonState()
    }
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


  func informThePlayer() {
    let alertController = UIAlertController(title: "Identify Yourself", message: "You must choose a name and image to identify you to other players. You can choose a default image or use your device's camera.", preferredStyle: UIAlertControllerStyle.Alert)

    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      println("Okay I will, thank you may i have another")
    }

    alertController.addAction(okAction)
    self.presentViewController(alertController, animated: true, completion: nil)

  }

    //MARK: - You probably won't need this stupid thing.
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}