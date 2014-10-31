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

    var missionDictionary : NSMutableDictionary! // May not be needed, we may have to fold things into a dictionary.
    var missionName : NSString // Name for the mission. Eventually we want a selection of them with names and descriptions.
    var missionDescription : NSString? // Description. Eventually we want a selection of them with names and descriptions.
    var success : Bool? // Whether the mission was a success. UI tests for nil if incomplete
    var playersNeeded : NSInteger! //
    var failThreshold : NSInteger!
    var rejectedTeamsCount : NSInteger = 0
    var nominatedPlayers = [Player]()
    var successCardsPlayed : NSInteger = 0
    var failCardsPlayed : NSInteger = 0
  

    init(missionDictionary: NSMutableDictionary) {
        var missionDictionary = missionDictionary
        self.missionName = missionDictionary["missionName"] as String!
        self.playersNeeded = missionDictionary["playersNeeded"] as NSInteger
        self.failThreshold = missionDictionary["failThreshold"] as NSInteger
        self.missionDictionary = missionDictionary as NSMutableDictionary!
    }

  convenience init (playersNeeded: NSInteger, failThreshold: NSInteger) {
      var missionDictionary = NSMutableDictionary()
      missionDictionary.setObject("Test Mission", forKey: "missionName")
      missionDictionary.setObject(playersNeeded, forKey: "playersNeeded")
      missionDictionary.setObject(failThreshold, forKey: "failThreshold")
    
      self.init (missionDictionary: missionDictionary as NSMutableDictionary!)
    }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.missionDictionary, forKey: "missionDictionary")
    aCoder.encodeObject(self.missionName, forKey: "missionName")
    aCoder.encodeObject(self.playersNeeded, forKey: "playersNeeded")
    aCoder.encodeObject(self.failThreshold, forKey: "failThreshold")
    aCoder.encodeObject(self.rejectedTeamsCount, forKey: "rejectedTeamCount")
    aCoder.encodeObject(self.nominatedPlayers, forKey: "nominatedPlayers")
    aCoder.encodeObject(self.successCardsPlayed, forKey: "successCardsPlayed")
    aCoder.encodeObject(self.failCardsPlayed, forKey: "failCardsPlayed")
    if self.missionDescription != nil{
      aCoder.encodeObject(self.missionDescription, forKey: "missionDescription")
    }
    if self.success != nil {
      aCoder.encodeObject(self.success, forKey: "success")
    }
    
  }
  
  required init(coder aDecoder: NSCoder) {
    self.missionName = aDecoder.decodeObjectForKey("missionName") as NSString
    self.playersNeeded = aDecoder.decodeObjectForKey("playersNeeded") as NSInteger
    self.failThreshold = aDecoder.decodeObjectForKey("failThreshold") as NSInteger
    self.rejectedTeamsCount = aDecoder.decodeObjectForKey("rejectedTeamCount") as NSInteger
    self.nominatedPlayers = aDecoder.decodeObjectForKey("nominatedPlayers") as [Player]
    self.successCardsPlayed = aDecoder.decodeObjectForKey("successCardsPlayed") as NSInteger
    self.failCardsPlayed = aDecoder.decodeObjectForKey("failCardsPlayed") as NSInteger
    if let desc = aDecoder.decodeObjectForKey("missionDescription") as? NSString {
      self.missionDescription = desc
    }
    if let successFor = aDecoder.decodeObjectForKey("success") as? Bool {
      self.success = successFor
    }
    if let dictionary = aDecoder.decodeObjectForKey("dictionary") as? NSMutableDictionary {
      self.missionDictionary = dictionary
    }
  }
  
} // End
