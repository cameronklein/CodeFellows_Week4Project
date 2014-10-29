//
//  Mission.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class Mission : NSObject, NSCoding {
//

    var missionDictionary : NSMutableDictionary // May not be needed, we may have to fold things into a dictionary.
    var missionName : NSString // Name for the mission. Eventually we want a selection of them with names and descriptions.
    var missionDescription : NSString? // Description. Eventually we want a selection of them with names and descriptions.
    var success : Bool? // Whether the mission was a success. UI tests for nil if incomplete
    var playersNeeded : NSInteger! //
    var failThreshold : NSInteger!
    var rejectedTeamsCount : NSInteger = 0
    var nominatedPlayers : NSMutableArray = NSMutableArray()

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
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.missionName, forKey: "missionName")
    aCoder.encodeObject(self.playersNeeded, forKey: "playersNeeded")
    aCoder.encodeObject(self.failThreshold, forKey: "failThreshold")
    aCoder.encodeObject(self.rejectedTeamsCount, forKey: "rejectedTeamCount")
    aCoder.encodeObject(self.nominatedPlayers, forKey: "nominatedPlayers")
    if let desc = self.missionDescription as NSString {
      aCoder.encodeObject(desc, forKey: "missionDescription")
    }
    if let successFor = self.success as? Bool {
      aCoder.encodeObject(successFor, forKey: "success")
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    self.missionName = aDecoder.decodeObjectForKey("missionName") as NSString
    self.playersNeeded = aDecoder.decodeObjectForKey("playersNeeded") as NSInteger
    self.failThreshold = aDecoder.decodeObjectForKey("failThreshold") as NSinteger
    self.rejectedTeamsCount = aDecoder.decodeObjectForKey("rejectedTeamCount") as NSInteger
    self.nominatedPlayers = aDecoder.decodeObjectForKey("nominatedPlayers") as NSMutableArray
    if let desc = aDecoder.decodeObjectForKey("missionDescription") as? NSString {
      self.missionDescription = desc
    }
    if let successFor = aDecoder.decodeObjectForKey("success") as? Bool {
      self.success = successFor
    }
  }
  
} // End
