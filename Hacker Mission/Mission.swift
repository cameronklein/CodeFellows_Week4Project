//
//  Mission.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class Mission {
    var missionDictionary : NSMutableDictionary
    var missionName : NSString
    var missionDescription : NSString?
    var success = false
    var playersNeeded : NSInteger?
    var failThreshold : NSInteger?
    var rejectedTeamsCount : NSInteger?
    var nominatedPlayers : NSMutableArray?

    init(missionDictionary: NSMutableDictionary) {
        var missionDictionary = missionDictionary
        self.missionName = missionDictionary["missionName"] as String!
        self.missionDictionary = missionDictionary as NSMutableDictionary!
    }

    convenience init () {

        var missionDictionary : NSMutableDictionary!
        missionDictionary?.setValue("Test Mission", forKey: "missionName")

        self.init (missionDictionary: missionDictionary as NSMutableDictionary!)
    }


} // End
