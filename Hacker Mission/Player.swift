//
//  Player.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class Player {
    var playerName : NSString
    var playerID : NSInteger
    var playerImage : UIImage?

    init(playerName: NSString) {
        self.playerName = playerName as NSString!
        let idGen = NSInteger(arc4random_uniform(999999))
        let playerForHash : NSString = playerName + String(idGen)
        let playerHash = playerForHash.hash as NSInteger!
        self.playerID = playerHash as NSInteger!
        NSUserDefaults.standardUserDefaults().setValue(self.playerName, forKey: "playerName")
        NSUserDefaults.standardUserDefaults().setValue(self.playerID, forKey: "playerID")
        if self.playerImage != nil {
            self.savePlayerImage(self.playerImage!)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func checkForSavedPlayer() -> Bool {
        if let playerID: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("playerID") {
            return true
        }
        return false

    }

    func getPlayerFromNSUSerDefaults () -> Player {
        var player : Player?
        player?.playerName = NSUserDefaults.standardUserDefaults().valueForKey("playerName") as String
        player?.playerID = NSUserDefaults.standardUserDefaults().valueForKey("playerID") as Int
        player?.playerImage = self.loadPlayerImage()
        return player as Player!

    }

    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = paths[0] as String;
        let fullPath = path.stringByAppendingPathComponent(name)

        return fullPath
    }

    func savePlayerImage (image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = self.documentsPathForFileName(relativePath)
        imageData.writeToFile(path, atomically: true)
        NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "path")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func loadPlayerImage () -> UIImage {

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





}
