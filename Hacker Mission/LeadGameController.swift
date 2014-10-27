//
//  LeadGameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation

class LeadGameController : MultiPeerDelegate {
  
  var multipeerController : MultiPeerController = MultiPeerController()
  var game : Game!
  
  init() {
    
  }
  
  func startLookingForPlayers() {
    multipeerController.startBrowsing()
  }
  
  func startGame() {
    multipeerController.stopBrowsing()
    self.game = Game()
  }

  func assignRoles(){
    
  }
  
  func revealCharacters() {
    multipeerController.sendEventToPeers(GameEvent.RevealCharacters)
  }
  
  func assignLeader() {
    
  }
  
  func startMission() {
    
  }
  
  func tellLeaderToNominatePlayers() {
    
  }
  
  func revealNominations() {
    
  }
  
  func tellPlayersToVote() {
    
  }
  
  func revealVotes() {
    
  }
  
  func tabulateVotes() {
    
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    
  }
  
  func tabulateMissionOutcome() {
    
  }
  
  func endMission() {
    
  }
  
  func updateScore() {
    
  }
  
  func endGame() {
    
  }
  
  func revealTeamsAtEndGame() {
    
  }
  
  
  // MARK - Multipeer Delegate Methods
  
  func handleEvents(event : GameEvent) {
    
  }
  
}

enum GameEvent : String {
  case Start            = "GameEventStart"
  case RevealCharacters = "GameEventRevealCharacters"
  case Vote             = "GameEventVote"
  case RevealVote       = "GameEventRevealVote"
  case End              = "GameEventEnd"
}

