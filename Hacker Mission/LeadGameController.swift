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
  var game : GameSession!
  
  init() {
    
  }
  
  func startLookingForPlayers() {
    multipeerController.startBrowsing()
  }
  
  func startGame() {
    multipeerController.stopBrowsing()
    self.game = GameSession()
  }

  func assignRoles(){
    let players = game.playerList as [PlayerForGame]
    let numberOfPlayers = players.count
    var numberOfAgents = 2
    switch numberOfPlayers {
    case 7, 8, 9:
      numberOfAgents = 3
    case 10:
      numberOfAgents = 4
    default:
      numberOfAgents = 2
    }
    var currentAgents = 0
    
    while currentAgents < numberOfAgents {
      let i = arc4random_uniform(UInt32(numberOfPlayers))
      if players[i].playerRole == .Agent {
        players[i].playerType = .Agent
        currentAgents++
      }
    }
    let j = arc4random_uniform(numberOfPlayers)
    players[j].isLeader = true
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    game.currentGameState = GameEvent.RevealCharacters
    multipeerController.sendEventToPeers(game: game)
  }
  
  func changeLeader() {
    //Assigns a leader for current mission and itterates through all players, per games rules, and gives them a chance to be leader.
    game.leaderIndex++
    if game.leaderIndex = game.players.count {
      game.leaderIndex = 0
    }
  }
  
  func startMission() {
    //Calculates how many hackers will go on a mission, and how many failures it requires for the mission to fail
    game.currentGameState = GameEvent.MissionStart
    multipeerController.sendEventToPeers(game:game)
    
  }
  
  func tellLeaderToNominatePlayers() {
    //Leader nominates the appropriate number of hackers to go on the mission
    game.currentGameState = GameEvent.NominatePlayers
    multipeerController.sendEventToPeers(game:game)
    
  }
  
  func revealNominations() {
    //Leader locks in their nominated team for the mission
    game.currentGameState = GameEvent.RevealNominations
    multipeerController.sendEventToPeers(game:game)
    
  }
  
  func tellPlayersToVote() {
    //All players vote to approve or reject the nominated team for the mission
    game.currentGameState = GameEvent.BeginVote
    multipeerController.sendEventToPeers(game:game)
  }
  
  func revealVotes() {
    //Displays all players votes to approve/reject the mission
    game.currentGameState = GameEvent.RevealVote
    multipeerController.sendEventToPeers(game:game)
    
  }
  
  func tabulateVotes() {
    //Calculates if the mission is approved or rejected
    
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    game.currentGameState = GameEvent.BeginMissionOutcome
    multipeerController.sendEventToPeers(game:game)
    
  }
  
  func tabulateMissionOutcome() {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
  }
    
  func revealMissionOutcome() {
    //Reveals if the mission is successful or fails
    game.currentGameState = GameEvent.RevealMissionOutcome
    multipeerController.sendEventToPeers(game:game)
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
  
  func handleEvent(event : GameEvent) {
    
  }
  
}
