//
//  UserInfo.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class UserInfo : NSObject, NSCoding {
    var userName : NSString
    var userID : NSInteger
    var userImage : UIImage?
    var userPeerID : NSString?
    var userObject = NSMutableData()
    var savePath : String?

  init(userName: NSString, userImage: UIImage) {
      self.userImage = userImage
      self.userName = userName as NSString
      let idGen = NSInteger(arc4random_uniform(999999))
      let userForHash : NSString = userName + String(idGen)
      let userHash = userForHash.hash as NSInteger!
      self.userID = userHash as NSInteger!
    }
  
  init(userName: NSString) {
    self.userName = userName as NSString
    let idGen = NSInteger(arc4random_uniform(999999))
    let userForHash : NSString = userName + String(idGen)
    let userHash = userForHash.hash as NSInteger!
    self.userID = userHash as NSInteger!
  }

    required init(coder aDecoder: NSCoder) {

      self.userName = aDecoder.decodeObjectForKey("userName") as NSString
      self.userID = aDecoder.decodeIntegerForKey("userID") as NSInteger
      let data = aDecoder.decodeObjectForKey("userImage") as NSData
      self.userImage = UIImage(data: data)!
      self.userPeerID = aDecoder.decodeObjectForKey("userPeerID") as NSString?

    }
  
     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userName, forKey: "userName")
        aCoder.encodeInteger(self.userID, forKey: "userID")
      let data = UIImageJPEGRepresentation(self.userImage, 1.0)
      aCoder.encodeObject(data, forKey: "userImage")
        if self.userPeerID != nil {
            aCoder.encodeObject(self.userPeerID, forKey: "userPeerID")
        }

    }

    class func wrapUserInfo(object: UserInfo) -> NSMutableData {

        var passUser = NSMutableData()
        passUser = NSKeyedArchiver.archivedDataWithRootObject(object) as NSMutableData

        return passUser
    }

    class func unwrapUserInfo(object: NSMutableData) -> UserInfo {
        var passedUser = NSKeyedUnarchiver.unarchiveObjectWithData(object) as UserInfo

        return passedUser as UserInfo

    }

  class func saveTheObject (object: UserInfo) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let filePath = appDelegate.documentsPath as String!
    println("Saving to File")

    NSKeyedArchiver.archiveRootObject(object, toFile: filePath)

    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(filePath) {
      println("save appears to be successful, saved file has been found")
    } else {
      println("save apears to have failed, no saved file found")
    }
    
  }

  class func loadTheObject() -> UserInfo {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let filePath = appDelegate.documentsPath as String!
    println("attempting to find the default user from the drive")
    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(filePath) {
      println("found the file, will attempt to load it")
    } else {
      println("no file found")
    }
    let aFile = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as UserInfo!
    println("the info I loded is for user  \(aFile.userName)")

    return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as UserInfo!


  }





} // End
