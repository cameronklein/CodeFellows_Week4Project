//
//  GameSession.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class GameSession {

    var players : NSMutableArray // Array of Player
    var missions : NSMutableArray // Array of Mission
    var leader : Player? // Get from players.objectAtIndex(Int)
    var currentMission : NSInteger? // Get from missions.objectAtIndex(Int)
    var currentGameState  : GameEvent?
    var failedMissionCount : NSInteger = 0
    var passedMissionCount : NSInteger = 0



    init (players: NSMutableArray, missions: NSMutableArray) {
        self.players = players
        self.missions = missions

    }

    required init(coder aDecoder: NSCoder) {

        self.players = aDecoder.decodeObjectForKey("players") as NSMutableArray
        self.missions = aDecoder.decodeObjectForKey("missions") as NSMutableArray
        self.leader = aDecoder.decodeObjectForKey("leader") as Player?
        let currentMissionFor = NSInteger(aDecoder.decodeIntForKey("currentMission"))
        self.currentMission = currentMissionFor
        let currentGameStateFor = aDecoder.decodeObjectForKey("currentGameState") as GameEvent.RawValue!
        var currentGameStateIs = GameEvent(rawValue: currentGameStateFor)
        self.currentGameState = currentGameStateIs
        self.failedMissionCount = aDecoder.decodeIntegerForKey("failedMissionCount") as NSInteger
        self.passedMissionCount = aDecoder.decodeIntegerForKey("passedMissionCount") as NSInteger

    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.players, forKey: "players")
        aCoder.encodeObject(self.missions, forKey: "missions")
        aCoder.encodeInteger(self.failedMissionCount, forKey: "failedMissionCount")
        aCoder.encodeInteger(self.passedMissionCount, forKey: "passedMissionCount")
        if self.leader != nil {
            aCoder.encodeObject(self.leader, forKey: "leader")
        }
        if self.currentMission != nil {
            aCoder.encodeObject(self.currentMission, forKey: "currentMission")
        }
        if self.currentGameState != nil {
            aCoder.encodeObject(self.currentGameState?.rawValue, forKey: "currentGameState")
        }

    }

    class func populateMissionList() -> NSMutableArray {
        var missionList : NSMutableArray?
        for item in 1...5 {
            var missionFor : Mission
            var mission = Mission()
            missionList?.addObject(mission as Mission!)
        }

        return missionList as NSMutableArray!

    }

    class func createGameSessionID(advertisorPlayer: Player) -> NSInteger {
        let playerName = advertisorPlayer.playerName as NSString!
        let idGen = NSInteger(arc4random_uniform(999999))
        let playerForHash : NSString = playerName + String(idGen)
        let gameIDHash = playerForHash.hash as NSInteger!

        return gameIDHash as NSInteger!
    }

    class func wrapGameSession(object: UserInfo) -> NSMutableData {

        var passGame = NSMutableData()
        passGame = NSKeyedArchiver.archivedDataWithRootObject(object) as NSMutableData

        return passGame
    }

    class func unwrapGameSession(object: NSMutableData) -> UserInfo {
        var passedGame = NSKeyedUnarchiver.unarchiveObjectWithData(object) as UserInfo

        return passedGame as UserInfo
        
    }
    
    
} // End
