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

    init(missionDictionary: NSMutableDictionary) {
        var missionDictionary = missionDictionary
        self.missionName = missionDictionary["missionName"] as String!
        self.missionDictionary = missionDictionary as NSMutableDictionary!
    }


}
