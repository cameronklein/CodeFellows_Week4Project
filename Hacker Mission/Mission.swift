//
//  Mission.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class Mission : NSObject {
//

    var missionDictionary : NSMutableDictionary // May not be needed, we may have to fold things into a dictionary.
    var missionName : NSString // Name for the mission. Eventually we want a selection of them with names and descriptions.
    var missionDescription : NSString? // Description. Eventually we want a selection of them with names and descriptions.
    var success : Bool? // Whether the mission was a success. UI tests for nil if incomplete
    var playersNeeded : NSInteger? //
    var failThreshold : NSInteger?
    var rejectedTeamsCount : NSInteger?
    var nominatedPlayers : NSMutableArray?

    init(missionDictionary: NSMutableDictionary) {
        var missionDictionary = missionDictionary
        self.missionName = missionDictionary["missionName"] as String!
        self.missionDictionary = missionDictionary as NSMutableDictionary!
    }

    convenience override init () {

        var missionDictionary : NSMutableDictionary!
        missionDictionary?.setValue("Test Mission", forKey: "missionName")

        self.init (missionDictionary: missionDictionary as NSMutableDictionary!)
    }




} // End
