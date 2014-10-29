//
//  ProposedTeam.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

//import UIKit
//
//// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
////                   Deprecated
//// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//
//class ProposedTeam {
//
//    var proposedTeamDictionary : NSMutableDictionary
//
//    var playerCount : NSInteger
//    var playersForMission : NSMutableArray?
//    var missionVotes : NSMutableDictionary?
//    var missionOrder : NSInteger
//
//    init(proposedTeamDictionary: NSMutableDictionary) {
//        var proposedTeamDictionary = proposedTeamDictionary as NSMutableDictionary!
//        self.missionOrder = proposedTeamDictionary["missionOrder"] as NSInteger!
//        self.playerCount = proposedTeamDictionary["playerCount"] as NSInteger!
//
//        self.proposedTeamDictionary = proposedTeamDictionary as NSMutableDictionary!
//    }
//
//    func createProposedTeam(missionOrder: NSInteger, playerCount: NSInteger) -> NSMutableDictionary {
//        var missionPotentialDictionary = NSMutableDictionary()
//        missionPotentialDictionary.setValue(missionOrder, forKey: "missionOrder")
//        missionPotentialDictionary.setValue(playerCount, forKey: "playerCount")
//
//        return missionPotentialDictionary as NSMutableDictionary
//        
//    }
//
//    func createArrayOfPlayersForProposedTeam () {
//
//    }
//
//    func createArrayOfVotesForProposedMission () {
//
//    }
//
//    func recordVoteResultsForProposedMission () {
//
//    }
//
//
//} // End
