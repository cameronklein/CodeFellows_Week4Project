//
//  Mission.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//
//
//import UIKit
//
//// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
////                   Deprecated
//// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//
//class ApprovedTeam {
//    var missionName : NSString
//    var missionDescription : NSString?
//    var playerCount : NSInteger
//    var gameSession : GameSession
//    var playersForMission : NSArray
//    var missionApprovedDictionary : NSMutableDictionary
//    var missionSuccess : Bool?
//    var missionVotes : NSDictionary
//    var missionResults : NSDictionary?
//    var missionOrder : NSInteger
//
//
//    init(missionApprovedDictionary: NSMutableDictionary) {
//        var missionApprovedDictionary = missionApprovedDictionary
//        self.missionName = missionApprovedDictionary.valueForKey("missionName") as NSString!
//        self.gameSession = missionApprovedDictionary.valueForKey("gameSession") as GameSession!
//        self.playersForMission = missionApprovedDictionary["playersForMission"] as NSArray!
//        self.playerCount = self.playersForMission.count as NSInteger
//        self.missionVotes = missionApprovedDictionary["missionVotes"] as NSDictionary!
//        self.missionOrder = missionApprovedDictionary["missionOrder"] as NSInteger!
//        self.missionApprovedDictionary = missionApprovedDictionary as NSMutableDictionary!
//    }
//
//
//
//
//}
