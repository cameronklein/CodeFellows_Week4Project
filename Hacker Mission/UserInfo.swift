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
    var userImage : UIImage
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
        NSUserDefaults.standardUserDefaults().setValue(self.userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().setValue(self.userID, forKey: "userID")
        UserInfo.saveUserImage(self.userImage)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    required init(coder aDecoder: NSCoder) {

        self.userName = aDecoder.decodeObjectForKey("userName") as NSString
        self.userID = aDecoder.decodeIntegerForKey("userID") as NSInteger
        self.userImage = aDecoder.decodeObjectForKey("userImage") as UIImage
        self.userPeerID = aDecoder.decodeObjectForKey("userPeerID") as NSString?

    }

     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userName, forKey: "userName")
        aCoder.encodeInteger(self.userID, forKey: "userID")
        aCoder.encodeObject(self.userImage, forKey: "userImage")
        if self.userPeerID != nil {
            aCoder.encodeObject(self.userPeerID, forKey: "userPeerID")
        }

    }

    class func checkForSavedUser() -> Bool {
        if let userID: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("userID") {
            return true
        }
        return false

    }

    class func getUserFromNSUSerDefaults () -> UserInfo {
        var userInfo : UserInfo?
        userInfo?.userName = NSUserDefaults.standardUserDefaults().valueForKey("userName") as String
        userInfo?.userID = NSUserDefaults.standardUserDefaults().valueForKey("userID") as Int
        userInfo?.userImage = UserInfo.loadUserImage()
        return userInfo as UserInfo!

    }

    class func documentsPathForFileName(name: String) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = paths[0] as String;
        let fullPath = path.stringByAppendingPathComponent(name)

        return fullPath
    }

     class func saveUserImage(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = UserInfo.documentsPathForFileName(relativePath)
        imageData.writeToFile(path, atomically: true)
        NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "path")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    class func loadUserImage() -> UIImage {

        let possibleOldImagePath = NSUserDefaults.standardUserDefaults().objectForKey("path") as NSString?
        if let oldImagePath = possibleOldImagePath {
            let pathFor = oldImagePath as NSString!
            let oldFullPath = UserInfo.documentsPathForFileName(pathFor)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            // here is your saved image:
            let oldImage = UIImage(data: oldImageData!)
            
            return oldImage!
            }

            return UIImage(named: "atSymbol")!
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





} // End
