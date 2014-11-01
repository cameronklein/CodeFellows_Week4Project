//
//  GameEvent.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation

enum GameEvent : NSString {
  case Start                = "GameEventStart"
  case RevealCharacters     = "GameEventRevealCharacters"
  case NominatePlayers      = "GameEventNominatePlayers"
  case RevealNominations    = "GameEventRevealNominations"
  case MissionStart         = "GameEventMissionStart"
  case RevealVote           = "GameEventRevealVote"
  case BeginVote            = "GameEventBeginVote"
  case BeginMissionOutcome  = "GameEventBeginMissionOutcome"
  case RevealMissionOutcome = "GameEventRevealOutcome"
  case End                  = "GameEventEnd"
}
