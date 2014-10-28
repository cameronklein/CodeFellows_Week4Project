//
//  GameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation

class GameController : MultiPeerDelegate {
  
  var game : GameSession
  
  func handleEvent(event: GameEvent) {
    switch event{
    case .Start:
      self.gameStart()
    case .RevealCharacters:
      self.revealCharacters()
    case .NominatePlayers:
      self.nominatePlayers()
    case .RevealNominations:
      self.revealNominations()
    case .MissionStart:
      self.startMission()
    case .Vote:
      self.vote()
    case .RevealVote:
      self.revealVotes()
    case .BeginVote:
      self.beginVote()
    case .BeginMissionOutcome:
      self.beginMissionOutcome()
    case .RevealMissionOutcome:
      self.revealMissionOutcome()
    case .End:
      self.endGame()
    }
  }
  
  func gameStart() {
    
  }
  
  func revealCharacters() {
    
  }
  
  func nominatePlayers() {
    
  }
  
  func revealNominations() {
    
  }
  
  func startMission() {
    
  }
  
  func vote() {
    
  }
  
  func revealVotes() {
    
  }
  
  func beginVote() {
    
  }
  
  func beginMissionOutcome() {
    
  }
  
  func revealMissionOutcome() {
    
  }
  
  func endGame() {
    
  }
  
}
