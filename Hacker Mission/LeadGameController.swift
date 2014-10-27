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
    //Takes in an array of players, and assigns their roles.
    
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    multipeerController.sendEventToPeers(GameEvent.RevealCharacters)
    
  }
  
  func assignLeader() {
    //Assigns a leader for current mission and itterates through all players, per games rules, and gives them a chance to be leader.
    
  }
  
  func startMission() {
    //Calculates how many hackers will go on a mission, and how many failures it requires for the mission to fail
    
  }
  
  func tellLeaderToNominatePlayers() {
    //Leader nominates the appropriate number of hackers to go on the mission
    
  }
  
  func revealNominations() {
    //Leader locks in their nominated team for the mission
    
  }
  
  func tellPlayersToVote() {
    //All players vote to approve or reject the nominated team for the mission
    
  }
  
  func revealVotes() {
    //Displays all players votes to approve/reject the mission
    
  }
  
  func tabulateVotes() {
    //Calculates if the mission is approved or rejected
    
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    
  }
  
  func tabulateMissionOutcome() {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
  }
    
  func revealMissionOutcome() {
    //Reveals if the mission is successful or fails
    }
  
  func endMission() {
    //Memorialize mission information, call updateScore, reset mission timer
    
  }
  
  func updateScore() {
    //Based on mission results upate the overall score
    
  }
  
  func endGame() {
    //Calls revealTeamsAtEndGame, displays who won the game
    
  }
  
  func revealTeamsAtEndGame() {
     //Displays on everyone's device who the goverment agents were
    
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

