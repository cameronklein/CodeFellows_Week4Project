//
//  LeadGameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//


import Foundation
import UIKit

class LeadGameController : MultiPeerDelegate {
  
  var multipeerController : MultiPeerController = MultiPeerController()
  var game : GameSession!
  var currentVotes = [Bool]()
  var usersForGame : NSMutableArray?
  var peerCount : Int = 0

  init() {
    multipeerController.delegate = self
  }
  
  func startLookingForPlayers() {
    multipeerController.startBrowsing()
  }

  func startGame() {
    multipeerController.stopBrowsing()
    var players = NSMutableArray()

    if self.usersForGame == nil {
        println("nil value for users for game, should be initialized")
    }

    for user in self.usersForGame! {
        
        var playerFor = Player.makePlayerDictionaryForGameSession(user as UserInfo)
        var player = Player(playerDictionary: playerFor)
        players.addObject(player)
    }
    var missions = GameSession.populateMissionList() as NSMutableArray // Temporary methid until we have a pool of individualized missions

    self.game = GameSession(players: players, missions: missions)
  }

  func assignRoles(){

    let players = game.players as NSArray
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
      let i = Int(arc4random_uniform(UInt32(numberOfPlayers)))
        let player = players[i] as Player
      if player.playerRole != PlayerType.Agent {
        player.playerRole = PlayerType.Agent
        currentAgents++
      }
    }
    let j = Int(arc4random_uniform(UInt32(numberOfPlayers)))
    var player = players[j] as Player
    player.isLeader = true
    game.leader = player
    self.revealCharacters()
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    game.currentGameState = GameEvent.RevealCharacters
    multipeerController.sendEventToPeers(game)
  }

  func changeLeader() {
    //Assigns a leader for current mission and itterates through all players, per games rules, and gives them a chance to be leader.
    var leaderIndex = game.players.indexOfObject(game.leader!)
    if leaderIndex == game.players.count {
      leaderIndex = 0
    } else {
        leaderIndex = leaderIndex + 1
    }
    let player = game.players[leaderIndex] as Player
    game.leader = player
    player.isLeader = true
  }

  func startMission() {
    //Calculates how many hackers will go on a mission, and how many failures it requires for the mission to fail
    game.currentGameState = GameEvent.MissionStart
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellLeaderToNominatePlayers() {
    //Leader nominates the appropriate number of hackers to go on the mission
    game.currentGameState = GameEvent.NominatePlayers
    multipeerController.sendEventToPeers(game)
    
  }
  
  func revealNominations() {
    //Leader locks in their nominated team for the mission
    game.currentGameState = GameEvent.RevealNominations
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellPlayersToVote() {
    //All players vote to approve or reject the nominated team for the mission
    game.currentGameState = GameEvent.BeginVote
    multipeerController.sendEventToPeers(game)
  }
  
  func tabulateVotes(dictionary: NSMutableDictionary) {
    
    //Calculates if the mission is approved or rejected
    
    let peerID = dictionary["peerID"] as String
    let vote = dictionary["votes"] as Bool
    currentVotes.append(vote)
    for player in game.players {
        let playerStaged = player as Player
      if playerStaged.peerID == peerID {
        playerStaged.currentVote = vote
      }
    }
    
    if currentVotes.count == game.players.count {
      var approved = 0
      var rejected = 0
      for vote in currentVotes {
        if vote {
          approved = approved + 1
        } else {
          rejected = rejected + 1
        }
      }
      if rejected > approved {
        let mission = game.missions[game.currentMission!] as Mission
        mission.rejectedTeamsCount =  mission.rejectedTeamsCount! + 1
      }
    }
    self.revealVotes()
  }
  
  func revealVotes() {
    //Displays all players votes to approve/reject the mission
    game.currentGameState = GameEvent.RevealVote
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    game.currentGameState = GameEvent.BeginMissionOutcome
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateMissionOutcome() {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
  }
    
  func revealMissionOutcome() {
    //Reveals if the mission is successful or fails
    game.currentGameState = GameEvent.RevealMissionOutcome
    multipeerController.sendEventToPeers(game)
  }
  
  func endMission() {
    //Memorialize mission information, call updateScore, reset mission timer
    
  }
  
  func updateScore() {
    //Based on mission results upate the overall score
    
  }
  
  func endGame() {
    //Calls revealTeamsAtEndGame, displays who won the game
    game.currentGameState = GameEvent.End
    multipeerController.sendEventToPeers(game)
  }
  
  func revealTeamsAtEndGame() {
     //Displays on everyone's device who the goverment agents were
    
  }
  
  // MARK - Multipeer Delegate Methods
  
  func handleEvent(event: NSMutableDictionary) {
    
    if let vote = event["vote"] as? Bool {
      self.tabulateVotes(event)
    }
    if let vote = event["missionOutcome"] as? Bool {
      self.tabulateVotes(event)
    }
    if let user = event["user"] as? UserInfo {
        user.userPeerID = event["peerID"] as? NSString
        self.usersForGame?.addObject(user)
    }
  }

    func handleEvent(event: GameEvent) {
        println("Something went wrong")
    }
  
  func updatePeerCount(count : Int) {
    self.peerCount = count
    if let root = UIApplication.sharedApplication().keyWindow?.rootViewController as? LaunchViewController {
      root.updateConnectedPeersLabel(count)
    }
  }
  
}
