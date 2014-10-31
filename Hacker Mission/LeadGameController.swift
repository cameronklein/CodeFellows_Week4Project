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
  
  var multipeerController : MultiPeerController = MultiPeerController.sharedInstance
  var game : GameSession!
  var currentVotes = [String]()
  var currentMissionOutcomeVotes = [String]()
  var usersForGame = [UserInfo]()
  var peerCount : Int = 0
  var myUserInfo : UserInfo!
  var launchVC : LaunchViewController!

  init() {
    multipeerController.mainBrainDelegate = self
  }
  
  func startLookingForPlayers() {
    myUserInfo = UserInfo(userName: "Boss Man", userImage: UIImage(named: "AtSymbol")!)
    myUserInfo.userPeerID = multipeerController.peerID.displayName
    myUserInfo.userImage = UIImage(named: "AtSymbol")!
    multipeerController.userInfo = self.myUserInfo
    usersForGame.append(self.myUserInfo)
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
    var missions = GameSession.populateMissionList(players.count) as NSMutableArray // Temporary method until we have a pool of individualized missions
    println("Created \(missions.count) missions.")
    
    self.game = GameSession(players: players, missions: missions)
    if self.game != nil {
      println("Game Created. We are ready for launch.")
      assignRoles()
    }
    let revealVC = RevealViewController(nibName: "RevealViewController", bundle: NSBundle.mainBundle())
    GameController.sharedInstance.revealVC = revealVC
    let playerArray = game.players
    for player in playerArray {
        println("\(multipeerController.peerID.displayName) is from Controller, \(player.peerID) is the local")
        if multipeerController.peerID.displayName == player.peerID {
            println("Entered the If")
            revealVC.user = player
        }
    }
//    let revealVC = UIStoryboard(name: "Main", bundle:
//        NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("HOME") as RevealViewController
    revealVC.game = self.game
    
    self.launchVC.gameStart(revealVC)
    }

  func assignRoles(){
    println("Beginning to assign player roles for \(game.players.count) players.")

    let players = game.players as NSArray
    let numberOfPlayers = players.count
    var numberOfAgents = 1
    switch numberOfPlayers {
    case 7, 8, 9:
      numberOfAgents = 3
    case 10:
      numberOfAgents = 4
    default:
      numberOfAgents = 1
    }
    var currentAgents = 0
    
    while currentAgents < numberOfAgents {
      let i = Int(arc4random_uniform(UInt32(numberOfPlayers)))
        let player = players[i] as Player
      if player.playerRole != PlayerType.Agent {
        println("Assigned \(player.playerName) as Agent.")
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
    println("Sending *Game Start* event to peers.")
    game.currentGameState = GameEvent.Start
    multipeerController.sendEventToPeers(game)
    self.revealCharacters()
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    println("Sending *Reveal Characters* event to peers.")
    game.currentGameState = GameEvent.RevealCharacters
    multipeerController.sendEventToPeers(game)
//    game.currentGameState = GameEvent.MissionStart
//    multipeerController.sendEventToPeers(game)
  }

  func changeLeader() {
    //Assigns a leader for current mission and itterates through all players, per games rules, and gives them a chance to be leader.
//    var leaderIndex = game.players.indexOfObject(game.leader!)
    println("Changing leader. Was \(game.leader!.playerName)")
    var foundLeader = false
    for player in game.players {
      if foundLeader == true {
        player.isLeader = true
        game.leader = player
        break
      }
      if player.isLeader == true {
        player.isLeader = false
        foundLeader = true
      }
    }
    if foundLeader == false {
      game.players.first!.isLeader = true
      game.leader = game.players.first!
    }
    println("New leader is \(game.leader!.playerName)")
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
  
  func tabulateVotes(forPlayer playerID : String, andVote voteResult : String) {
    
    //Calculates if the mission is approved or rejected
    println("Vote receieved from \(playerID).")
    currentVotes.append(voteResult)
    for player in game.players {
      if player.peerID == playerID {
        if voteResult == "Approve" {
          player.currentVote = true
        } else if voteResult == "Reject" {
          player.currentVote = false
        }
      }
    }
    
    if currentVotes.count == game.players.count {
      println("Last vote received. Deciding winner...")
      println(currentVotes.description)
      var approved = 0
      var rejected = 0
      for vote in currentVotes {
        if vote == "Approve" {
          approved = approved + 1
        } else if vote == "Reject" {
          rejected = rejected + 1
        }
      }
      var didPass = false
      if rejected > approved {
        println("Team REJECTED by players. (Approved: \(approved). Rejected: \(rejected).")
        let mission = game.missions[game.currentMission] as Mission
        mission.rejectedTeamsCount =  mission.rejectedTeamsCount + 1
      } else {
        println("Team APPROVED by players. (Approved: \(approved). Rejected: \(rejected).")
        didPass = true
      }
      currentVotes.removeAll(keepCapacity: true)      //Reset currentVotes
      self.revealVotes(didPass)
    }
  }
  
  func revealVotes(passed: Bool) {
    //Displays all players votes to approve/reject the mission
    println("Sending *Reveal Vote* event to peers.")
    game.currentGameState = GameEvent.RevealVote
    multipeerController.sendEventToPeers(game)
    if passed == false {
      self.changeLeader()
      self.tellLeaderToNominatePlayers()
      for player in game.players {
        player.currentVote = nil
      }
      let currentMission = game.missions[game.currentMission] as Mission
      currentMission.nominatedPlayers.removeAll(keepCapacity: true)
    } else {
      self.tellPlayersToDetermineMissionOutcome()
    }
    
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    println("Sending *Begin Mission Outcome* event to peers.")
    game.currentGameState = GameEvent.BeginMissionOutcome
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateMissionOutcome(forPlayer playerID : String, andOutcome outcome: String) {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
    println("Mission outcome vote received from \(playerID)")
    currentMissionOutcomeVotes.append(outcome)
    let currentMission = game.missions[game.currentMission] as Mission
    if currentMissionOutcomeVotes.count == currentMission.playersNeeded {
      var succeed = 0
      var fail = 0
      for vote in currentMissionOutcomeVotes {
        if vote == "succeed" {
          succeed = succeed + 1
          currentMission.successCardsPlayed = currentMission.successCardsPlayed + 1
        } else if vote == "fail" {
          currentMission.failCardsPlayed = currentMission.failCardsPlayed + 1
          fail = fail + 1
        }
      }
      if fail >= currentMission.failThreshold {
        println("Mission Failed!!!")
        currentMission.success = false
        game.failedMissionCount = game.failedMissionCount + 1
      } else {
        println("Mission Succeeded!!!")
        currentMission.success = true
        game.passedMissionCount = game.passedMissionCount + 1
      }
      revealMissionOutcome()
      }
  }
  
    
  func revealMissionOutcome() {
    //Reveals if the mission is successful or fails
    println("Sending *Reveal Mission Outcome* event to peers.")
    game.currentGameState = GameEvent.RevealMissionOutcome
    multipeerController.sendEventToPeers(game)
  }
  
  func endMission() {
    //Memorialize mission information, call updateScore, reset mission timer
    var currentMission = game.missions[game.currentMission] as Mission
    println("Updating mission number index.")
    if game.passedMissionCount == 3 || game.failedMissionCount == 3 {
      self.endGame()
    } else {
      game.currentMission = game.currentMission + 1
      self.changeLeader()
      self.startMission()
    }
  }
  
//  func updateScore() {
//    //Based on mission results upate the overall score
//    
//  }
  
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
    println(event.description)
    let action  = event["action"] as String
    let peerID  = event["peerID"] as String
    
    switch action{
    case "vote" :
      println("Received vote information from \(peerID)")
      let value = event["value"] as String
      self.tabulateVotes(forPlayer: peerID, andVote: value)
    case "missionOutcome" :
      println("Received mission outcome information from \(peerID)")
      let value = event["value"] as String
      self.tabulateMissionOutcome(forPlayer: peerID, andOutcome: value)
    case "user" :
      println("Received user information from \(peerID)")
      let value = event["value"] as UserInfo
      usersForGame.append(value)
    case "nominations" :
      println("Received nomination information from \(peerID)")
      let value = event["value"] as [String]
      self.assignNominations(value)
    default:
      println("LeadGameController event handler action not recognized.")
    }
  }
  
  func assignNominations(arrayOfNominatedPlayerIDs : [String]) {
    let currentMission = game.missions[game.currentMission] as Mission
    for player in game.players {
      for nominationID in arrayOfNominatedPlayerIDs {
        if nominationID == player.peerID {
          println("Added \(player.playerName) to mission # \(game.currentMission)'s nominatedPlayer array.")
          currentMission.nominatedPlayers.append(player)
        }
      }
    }
    self.revealNominations()
    
  }

    func handleEvent(event: GameSession) {
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
