//
//  PlayerForGame.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

enum PlayerType : Int {
  case Hacker = 1
  case Agent = 2
}

class PlayerForGame {

    var playerDictionary : NSMutableDictionary

    var playerName : NSString
    var playerID : NSString
    var playerImage : UIImage
    var playerRole : PlayerType
    var gameSessionID : Int
    var isNominated =  false
    var isLeader = false


    init(playerDictionary: NSMutableDictionary) {
        var playerDictionary = playerDictionary as NSMutableDictionary
        self.playerName = playerDictionary["playerName"] as NSString!
        self.playerID = playerDictionary["playerID"] as NSString!
        self.playerRole = PlayerType(rawValue: playerDictionary["playerType"] as Int)!
        self.gameSessionID = playerDictionary["gameSession"] as NSInteger!
        self.playerDictionary = playerDictionary
        self.playerImage = playerDictionary["playerImage"] as UIImage!
    }


    func makePlayerDictionaryForGameSession (player: Player, gameSessionID: NSInteger, playerType: PlayerType) -> NSDictionary {
        var playerDictionary = NSMutableDictionary()
        playerDictionary.setValue(playerName, forKey: "playerName")
        playerDictionary.setValue(playerID, forKey: "playerID")
        var imageFor = player.playerImage?.imageAsset as NSData!
        playerDictionary.setValue(imageFor, forKey: "playerImage")
        playerDictionary.setValue(gameSessionID, forKey: "gameSessionID")
        playerDictionary.setValue(playerType.rawValue, forKey: "playerType")
      return playerDictionary
    }
}
