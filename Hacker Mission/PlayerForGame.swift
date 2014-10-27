//
//  PlayerForGame.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class PlayerForGame {

    var playerDictionary : NSMutableDictionary

    var playerName : NSString
    var playerID : NSString
    var playerImage : UIImage
    enum playerType : Int {
        case Hacker = 1
        case Agent = 2
    }
    var playerRole : playerType
    var gameSessionID : Int
    var isNominated =  false
    var isLeader = false


    init(playerDictionary: NSMutableDictionary) {
        var playerDictionary = playerDictionary as NSMutableDictionary
        self.playerName = playerDictionary["playerName"] as NSString!
        self.playerID = playerDictionary["playerID"] as NSString!
        self.playerRole = playerDictionary["playerType"] as PlayerForGame.playerType!
        self.gameSessionID = playerDictionary["gameSession"] as NSInteger!
        self.playerDictionary = playerDictionary
        self.playerImage = playerDictionary["playerImage"] as UIImage!
    }


    func makePlayerDictionaryForGameSession (player: Player, gameSessionID: NSInteger, playerType: PlayerForGame.playerType) -> NSDictionary {
        var playerDictionary : NSDictionary
        playerDictionary.setValue(playerName, forKey: "playerName")
        playerDictionary.setValue(playerID, forKey: "playerID")
        var imageFor = player.playerImage?.imageAsset as NSData!
        playerDictionary.setValue(imageFor, forKey: "playerImage")
        playerDictionary.setValue(gameSessionID, forKey: "gameSessionID")
        playerDictionary.setValue(PlayerForGame.playerType.RawValue(), forKey: "playerType")
    }


}
