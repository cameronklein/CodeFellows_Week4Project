//
//  ImagePacket.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 11/1/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKIT

class ImagePacket : NSObject, NSCoding {
  var userImage : UIImage
  var userPeerID : NSString?
  //var imagePacketObject = NSMutableData()
  var savePath : String?

  init(peerID: NSString, userImage: UIImage) {
    self.userImage = userImage as UIImage
    self.userPeerID = peerID as NSString
  }

  required init(coder aDecoder: NSCoder) {
    //let data = aDecoder.decodeObjectForKey("userImage") as NSData
    self.userImage = aDecoder.decodeObjectForKey("userImage") as UIImage
    self.userPeerID = aDecoder.decodeObjectForKey("userPeerID") as NSString?

  }

  func encodeWithCoder(aCoder: NSCoder) {
    //let data = UIImagePNGRepresentation(self.userImage)
    aCoder.encodeObject(userImage, forKey: "userImage")
    aCoder.encodeObject(self.userPeerID, forKey: "userPeerID")
    
  }


  class func wrapImagePacket(object: ImagePacket) -> NSMutableData {

    var passPacket = NSMutableData()
    passPacket = NSKeyedArchiver.archivedDataWithRootObject(object) as NSMutableData

    return passPacket
  }

  class func unwrapImagePacket(object: NSMutableData) -> ImagePacket {
    var passedPacket = NSKeyedUnarchiver.unarchiveObjectWithData(object) as ImagePacket
    
    return passedPacket as ImagePacket!

  }





} // End
