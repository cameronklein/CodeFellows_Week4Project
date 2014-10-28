//
//  UserInfo.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class UserInfo {
    var userName : NSString
    var userID : NSInteger
    var userImage : UIImage?
    var userPeerID : NSString?

    init(userName: NSString) {
        self.userName = userName as NSString!
        let idGen = NSInteger(arc4random_uniform(999999))
        let userForHash : NSString = userName + String(idGen)
        let userHash = userForHash.hash as NSInteger!
        self.userID = userHash as NSInteger!
        NSUserDefaults.standardUserDefaults().setValue(self.userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().setValue(self.userID, forKey: "userID")
        if self.userImage != nil {
            self.saveUserImage(self.userImage!)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func checkForSavedUser() -> Bool {
        if let userID: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("userID") {
            return true
        }
        return false

    }

    func getUserFromNSUSerDefaults () -> UserInfo {
        var userInfo : UserInfo?
        userInfo?.userName = NSUserDefaults.standardUserDefaults().valueForKey("userName") as String
        userInfo?.userID = NSUserDefaults.standardUserDefaults().valueForKey("userID") as Int
        userInfo?.userImage = self.loadUserImage()
        return userInfo as UserInfo!

    }

    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = paths[0] as String;
        let fullPath = path.stringByAppendingPathComponent(name)

        return fullPath
    }

    func saveUserImage (image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = self.documentsPathForFileName(relativePath)
        imageData.writeToFile(path, atomically: true)
        NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "path")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func loadUserImage () -> UIImage {

    let possibleOldImagePath = NSUserDefaults.standardUserDefaults().objectForKey("path") as String?
    if let oldImagePath = possibleOldImagePath {
        let oldFullPath = self.documentsPathForFileName(oldImagePath)
        let oldImageData = NSData(contentsOfFile: oldFullPath)
        // here is your saved image:
        let oldImage = UIImage(data: oldImageData!)
        
        return oldImage!
        }

        return UIImage(named: "atSymbol")!
    }





} // End
