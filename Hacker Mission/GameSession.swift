//
//  GameSession.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class GameSession: NSObject, NSCoding {

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
        println("Attemping to encode gamesession with GameSession Info \(self.players.description)")
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
      var mission1 = (Int, Int)
      var mission2 = (Int, Int)
      var mission3 = (Int, Int)
      var mission4 = (Int, Int)
      var mission5 = (Int, Int)
      switch players.count{
      case 5:
        mission1 = (2, 1)
        mission2 = (3, 1)
        mission3 = (2, 1)
        mission4 = (3, 1)
        mission5 = (3, 1)
      case 6:
        mission1 = (2, 1)
        mission2 = (3, 1)
        mission3 = (4, 1)
        mission4 = (3, 1)
        mission5 = (4, 1)
      case 7:
        mission1 = (2, 1)
        mission2 = (3, 1)
        mission3 = (3, 1)
        mission4 = (4, 2)
        mission5 = (4, 1)
      case 8:
        mission1 = (3, 1)
        mission2 = (4, 1)
        mission3 = (4, 1)
        mission4 = (5, 2)
        mission5 = (5, 1)
      case 9:
        mission1 = (3, 1)
        mission2 = (4, 1)
        mission3 = (4, 1)
        mission4 = (5, 2)
        mission5 = (5, 1)
      case 10:
        mission1 = (3, 1)
        mission2 = (4, 1)
        mission3 = (4, 1)
        mission4 = (5, 2)
        mission5 = (4, 1)
      }
      var missionList = NSMutableArray()
      
      missionList.addObject(Mission(playersNeeded: mission1.1, failThreshold: mission1.2))
      missionList.addObject(Mission(playersNeeded: mission2.1, failThreshold: mission2.2))
      missionList.addObject(Mission(playersNeeded: mission3.1, failThreshold: mission3.2))
      missionList.addObject(Mission(playersNeeded: mission4.1, failThreshold: mission4.2))
      missionList.addObject(Mission(playersNeeded: mission5.1, failThreshold: mission5.2))
      
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
