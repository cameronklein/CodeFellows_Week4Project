//
//  MissionPotential.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ProposedTeam {

    var missionPotentialDictionary : NSMutableDictionary

    var missionName : NSString
    var missionDescription : NSString?
    var playerCount : NSInteger
    var missionOrder : NSInteger
    var missionVotes : NSMutableDictionary?

    init(missionPotentialDictionary: NSMutableDictionary) {
        var missionPotentialDictionary = missionPotentialDictionary
        self.missionName = missionPotentialDictionary["missionName"] as NSString!
        self.missionOrder = missionPotentialDictionary["missionOrder"] as NSInteger!
        self.playerCount = missionPotentialDictionary["playerCount"] as NSInteger!

        self.missionPotentialDictionary = missionPotentialDictionary as NSMutableDictionary!
    }

    func createMissionPotential (missionDictionary: NSMutableDictionary, missionOrder: NSInteger, playerCount: NSInteger) -> NSMutableDictionary {
        var missionPotentialDictionary = NSMutableDictionary()
        missionPotentialDictionary.setValue(missionDictionary["missionName"], forKey: "missionName")
        missionPotentialDictionary.setValue(missionOrder, forKey: "missionOrder")
        missionPotentialDictionary.setValue(playerCount, forKey: "playerCount")

        return missionPotentialDictionary as NSMutableDictionary
        
    }



}
