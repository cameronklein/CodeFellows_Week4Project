//
//  GameSession.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class GameSession {

<<<<<<< HEAD
    var players : NSMutableArray // Array of Player
    var missions : NSMutableArray // Array of Mission
    var leader : Int? // Get from players.objectAtIndex(Int)
    var currentMission : Int? // Get from missions.objectAtIndex(Int)


=======
    var gameSessionID     : NSInteger!
    var playerList        : [PlayerForGame]!
    var missionList       : [Mission]!
    var currentGameState  : GameEvent
>>>>>>> master

    init (players: NSMutableArray, missions: NSMutableArray) {
        self.players = players
        self.missions = missions

    }


    func populateMissionList () -> NSMutableArray {
        var missionList : NSMutableArray?
        for item in 1...5 {
            var missionFor : Mission
            var mission = Mission()
            missionList?.addObject(mission as Mission!)
        }

        return missionList as NSMutableArray!

    }

    func createGameSessionID(advertisorPlayer: Player) -> NSInteger {
        let playerName = advertisorPlayer.playerName as NSString!
        let idGen = NSInteger(arc4random_uniform(999999))
        let playerForHash : NSString = playerName + String(idGen)
        let gameIDHash = playerForHash.hash as NSInteger!

        return gameIDHash as NSInteger!
    }


} // End
