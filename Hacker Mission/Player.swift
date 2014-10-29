//
//  PlayerForGame.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

enum PlayerType: NSInteger {
    case Hacker = 1, Agent
}

class Player {

    var playerDictionary : NSMutableDictionary

    var playerName : NSString 
    var playerID : NSString
    var peerID : NSString
    var playerImage : UIImage
    var playerRole : PlayerType
    var isNominated =  false
    var isLeader = false
    var currentVote : Bool?


    init(playerDictionary: NSMutableDictionary) {
        var playerDictionary = playerDictionary as NSMutableDictionary
        self.playerName = playerDictionary["playerName"] as NSString!
        self.playerID = playerDictionary["playerID"] as NSString!
        self.playerRole =  PlayerType(rawValue: playerDictionary["playerType"] as Int)!
        self.playerDictionary = playerDictionary
        self.playerImage = playerDictionary["playerImage"] as UIImage!
        self.peerID = playerDictionary["peerID"] as NSString!
    }


    class func makePlayerDictionaryForGameSession (userInfo: UserInfo) -> NSMutableDictionary {
        var playerDictionary = NSDictionary()
        playerDictionary.setValue(userInfo.userName, forKey: "playerName")
        playerDictionary.setValue(userInfo.userID, forKey: "playerID")
        playerDictionary.setValue(userInfo.userPeerID, forKey: "peerID")
        //var imageFor = userInfo.userImage.imageAsset as NSData
        playerDictionary.setValue(userInfo.userImage, forKey: "playerImage")
//        playerDictionary?.setValue(playerType.rawValue, forKey: "playerType")

        return playerDictionary as NSMutableDictionary
    }



} // End
