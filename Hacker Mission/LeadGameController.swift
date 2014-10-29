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
  var usersForGame = [UserInfo]()
  var peerCount : Int = 0
    var userInfo : UserInfo?

  init() {
    multipeerController.delegate = self
  }
  
  func startLookingForPlayers() {
    self.userInfo = UserInfo(userName: "Boss Man")
    multipeerController.userInfo = self.userInfo
    multipeerController.startBrowsing()
  }

  func startGame() {
    
    println("Start Game Called on Master View Controller")
    
    multipeerController.stopBrowsing()
    //send start game command to all users
   // multipeerController.sendEventToPeers(game: GameSession)
    var players : [Player] = []

      for user in usersForGame {
        
          var playerFor = Player.makePlayerDictionaryForGameSession(user as UserInfo)
          var player = Player(playerDictionary: playerFor) as Player
        var needToAdd : Bool = true
        for existingPlayer in players {
            if (existingPlayer.playerID == player.playerID) {
                needToAdd = false
            }
        }
        if (needToAdd) {
            players.append(player)
        }
      }
    
//    var players = usersForGame.map { (UserInfo) -> U in
//      return Player(Player.makePlayerDictionaryForGameSession(UserInfo))
//    }
    println("\(players.count) players created from provided user information.")
    var missions = GameSession.populateMissionList() as NSMutableArray // Temporary method until we have a pool of individualized missions
    self.game = GameSession(players: NSMutableArray(array:players), missions: missions)
    if self.game != nil {
      println("Game Created. We are ready to start.")
    }
    }

  func assignRoles(){
    println("Beginning to assign player roles for \(game.players.count) players.")

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
    
    println("Assigned \(currentAgents) agents at random.")
    
    let j = Int(arc4random_uniform(UInt32(numberOfPlayers)))
    var player = players[j] as Player
    player.isLeader = true
    game.leader = player
    
    println("Assigned \(player.playerName) as initial leader.")
    
    self.revealCharacters()
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    println("Sending *Reveal Characters* event to peers.")
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
    println("Changing leader. Was \((game.players[leaderIndex] as Player).playerName)")
    let player = game.players[leaderIndex] as Player
    game.leader = player
    player.isLeader = true
    println("New leader is \((game.players[leaderIndex] as Player).playerName)")
  }

  func startMission() {
    //Calculates how many hackers will go on a mission, and how many failures it requires for the mission to fail
    println("Sending *Mission Start* event to peers.")
    game.currentGameState = GameEvent.MissionStart
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellLeaderToNominatePlayers() {
    //Leader nominates the appropriate number of hackers to go on the mission
    println("Sending *Nominate Players* event to peers.")
    game.currentGameState = GameEvent.NominatePlayers
    multipeerController.sendEventToPeers(game)
    
  }
  
  func revealNominations() {
    //Leader locks in their nominated team for the mission
    println("Sending *Reveal Nominations* event to peers.")
    game.currentGameState = GameEvent.RevealNominations
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellPlayersToVote() {
    //All players vote to approve or reject the nominated team for the mission
    println("Sending *Begin Vote* event to peers.")
    game.currentGameState = GameEvent.BeginVote
    multipeerController.sendEventToPeers(game)
  }
  
  func tabulateVotes(forPlayer playerID : String, andVote voteResult : Bool) {
    
    //Calculates if the mission is approved or rejected
    println("Vote receieved from \(playerID).")
    currentVotes.append(voteResult)
    for player in game.players {
        let playerStaged = player as Player
      if playerStaged.peerID == playerID {
        playerStaged.currentVote = voteResult
      }
    }
    
    if currentVotes.count == game.players.count {
      println("Last vote received. Deciding winner...")
      var approved = 0
      var rejected = 0
      for vote in currentVotes {
        if voteResult {
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
    println("Sending *Reveal Vote* event to peers.")
    game.currentGameState = GameEvent.RevealVote
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    println("Sending *Begin Mission Outcome* event to peers.")
    game.currentGameState = GameEvent.BeginMissionOutcome
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateMissionOutcome(forPlayer playerID : String, andOutcome outcome: String) {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
  }
    
  func revealMissionOutcome() {
    //Reveals if the mission is successful or fails
    println("Sending *Reveal Mission Outcome* event to peers.")
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
    let action  = event["action"] as String
    let peerID  = event["peerID"] as String
    
    switch action{
    case "vote" :
      let value = event["value"] as Bool
      self.tabulateVotes(forPlayer: peerID, andVote: value)
    case "missionOutcome" :
      let value = event["value"] as String
      self.tabulateMissionOutcome(forPlayer: peerID, andOutcome: value)
    case "user" :
      let value = event["value"] as UserInfo
      usersForGame.append(value)
    default:
      println("LeadGameController event handler action not recognized.")
    }
  }

    func handleEvent(event: GameEvent) {
        println("Something went wrong. This should not be called.")
    }
  
  func updatePeerCount(count : Int) {
    self.peerCount = count
    if let root = UIApplication.sharedApplication().keyWindow?.rootViewController as? LaunchViewController {
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        root.updateConnectedPeersLabel(count)
        //collect userInfo as users join
      })
    }
  }
  
}
