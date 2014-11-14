//
//  Log.swift
//  Hacker Mission
//
//  Created by Nathan Birkholz on 11/13/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation

class LogClass {

  var intFor : Int

  init() {
    intFor = 42
  }

  func DLog(message: String, function: String = __FUNCTION__) {
    #if DEBUG
      println("\(function): \(message)")
    #endif
  }
}