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
  var flavorTextArray = [(String,String)]()

  init() {
    multipeerController.mainBrainDelegate = self
    self.loadFlavorTextIntoArray()
  }
  
  func startLookingForPlayers() {
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    if let thisUser = appDel.defaultUser as UserInfo! {
      println("thisUser is \(thisUser)")
      thisUser.userPeerID = multipeerController.peerID.displayName
      usersForGame.append(thisUser)
    }
    multipeerController.startBrowsing()
  }

  func startGame() {
    
    println("MAIN BRAIN : Start Game Function Called")
    
    multipeerController.stopBrowsing()
  
    let players = self.getPlayersFromCurrentUsersArray()
    
    println("MAIN BRAIN: \(players.count) players created from provided user information.")
    println("PLAYERS DESC: \(players.description)")
    
    var missions = GameSession.populateMissionList(players.count)
    
    self.giveFlavorTextToMissions(&missions)
    
    println("MAIN BRAIN: Created \(missions.count) missions.")
    
    self.game = GameSession(players: players, missions: missions)
    
    if self.game != nil {
      println("MAIN BRAIN: Game Created. We are ready for launch.")
      self.assignRoles()
    }
    
    let revealVC = RevealViewController(nibName: "RevealViewController", bundle: NSBundle.mainBundle())
    GameController.sharedInstance.revealVC = revealVC
    
    for player in game.players {
      if multipeerController.peerID.displayName == player.peerID {
        //revealVC.user = player
      }
    }
    
    self.launchVC.gameStart(revealVC)
    }
  
  func getPlayersFromCurrentUsersArray() -> [Player] {
    
    var players = [Player]()
    println("MAIN BRAIN : Creating players from user array of \(usersForGame.count) users.")
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
    println("MAIN BRAIN : Created \(players.count) players.")
    
    return players
  }
  
  func giveFlavorTextToMissions(inout missions: [Mission]) {
    
    for mission in missions {
      
      let flavorTextIndex = Int(arc4random_uniform(UInt32(flavorTextArray.count)))
      mission.missionName = flavorTextArray[flavorTextIndex].0
      mission.missionDescription = flavorTextArray[flavorTextIndex].1
      flavorTextArray.removeAtIndex(flavorTextIndex)
      
    }
  }

  func assignRoles(){
    println("MAIN BRAIN: Beginning to assign player roles for \(game.players.count) players.")

    let players = game.players
    let numberOfPlayers = players.count
    var numberOfAgents = 1
    switch numberOfPlayers {
    case 5, 6:
      numberOfAgents = 2
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
        println("MAIN BRAIN: Assigned \(player.playerName) as Agent.")
        player.playerRole = PlayerType.Agent
        currentAgents++
      }
    }
    
    println("MAIN BRAIN: Assigned \(currentAgents) agents at random.")
    
    let j = Int(arc4random_uniform(UInt32(numberOfPlayers)))
    var player = players[j] as Player
    player.isLeader = true
    game.leader = player
    
    println("MAIN BRAIN: Assigned \(player.playerName) as initial leader.")
    println("MAIN BRAIN: Sending *Game Start* event to peers.")
    game.currentGameState = GameEvent.Start
    multipeerController.sendEventToPeers(game)
    self.revealCharacters()
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    println("MAIN BRAIN: Sending *Reveal Characters* event to peers.")
    game.currentGameState = GameEvent.RevealCharacters
    multipeerController.sendEventToPeers(game)
//    game.currentGameState = GameEvent.MissionStart
//    multipeerController.sendEventToPeers(game)
  }

  func changeLeader() {
    //Assigns a leader for current mission and itterates through all players, per games rules, and gives them a chance to be leader.
//    var leaderIndex = game.players.indexOfObject(game.leader!)
    println("MAIN BRAIN: Changing leader. Was \(game.leader!.playerName)")
    var foundLeader = false
    var assignedLeader = false
    
    if game.players.last!.isLeader == true {
      game.players.last!.isLeader = false
      game.players.first!.isLeader = true
      game.leader = game.players.first!
    } else {
      for player in game.players {
        if foundLeader == true && assignedLeader == false {
          player.isLeader = true
          game.leader = player
          assignedLeader = true
        } else if player.isLeader == true {
          player.isLeader = false
          foundLeader = true
        }
      }
    }
    println("MAIN BRAIN: New leader is \(game.leader!.playerName)")
  }

  func startMission() {
    //Calculates how many hackers will go on a mission, and how many failures it requires for the mission to fail
    println("MAIN BRAIN: Sending *Mission Start* event to peers.")
    game.currentGameState = GameEvent.MissionStart
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellLeaderToNominatePlayers() {
    //Leader nominates the appropriate number of hackers to go on the mission
    println("MAIN BRAIN: Sending *Nominate Players* event to peers.")
    for player in game.players {
      
      player.currentVote = nil
      player.isNominated = false
    }
    
    game.currentGameState = GameEvent.NominatePlayers
    multipeerController.sendEventToPeers(game)
    
  }
  
  func revealNominations() {
    //Leader locks in their nominated team for the mission
    println("MAIN BRAIN: Sending *Reveal Nominations* event to peers.")
    game.currentGameState = GameEvent.RevealNominations
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellPlayersToVote() {
    //All players vote to approve or reject the nominated team for the mission
    println("MAIN BRAIN: Sending *Begin Vote* event to peers.")
    game.currentGameState = GameEvent.BeginVote
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateVotes(forPlayer playerID : String, andVote voteResult : String) {
    
    //Calculates if the mission is approved or rejected
    println("MAIN BRAIN: Vote receieved from \(playerID).")
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
      println("MAIN BRAIN: Last vote received. Deciding winner...")
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
        println("MAIN BRAIN: Team REJECTED by players. (Approved: \(approved). Rejected: \(rejected).")
        let mission = game.missions[game.currentMission] as Mission
        mission.rejectedTeamsCount =  mission.rejectedTeamsCount + 1
      } else {
        println("MAIN BRAIN: Team APPROVED by players. (Approved: \(approved). Rejected: \(rejected).")
        didPass = true
      }
      currentVotes.removeAll(keepCapacity: true)      //Reset currentVotes
      self.revealVotes(didPass)
    }
  }
  
  func revealVotes(passed: Bool) {
    
    //Displays all players votes to approve/reject the mission
    println("MAIN BRAIN: Sending *Reveal Vote* event to peers.")
    game.currentGameState = GameEvent.RevealVote
    multipeerController.sendEventToPeers(game)
    let currentMission = game.missions[game.currentMission] as Mission
    
    if currentMission.rejectedTeamsCount == 5 {
      
      currentMission.success = false
      game.failedMissionCount = game.failedMissionCount + 1
      revealMissionOutcome()
      
    } else if passed == false {
      
      self.changeLeader()
      
      self.delay(10.0, closure: { () -> () in
        self.tellLeaderToNominatePlayers()
      })

      currentMission.nominatedPlayers.removeAll(keepCapacity: true)
      
    } else if passed == true {
      
      println("MAIN BRAIN: Telling nominated players to determine mission outcome! Nominated players: \(currentMission.nominatedPlayers.description)")
      
      self.delay(10.0, closure: { () -> () in
       self.tellPlayersToDetermineMissionOutcome()
      })
    }
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    println("MAIN BRAIN: Sending *Begin Mission Outcome* event to peers.")
    game.currentGameState = GameEvent.BeginMissionOutcome
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateMissionOutcome(forPlayer playerID : String, andOutcome outcome: String) {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
    println("MAIN BRAIN: Mission outcome vote received from \(playerID)")
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
        println("MAIN BRAIN: Mission Failed!!!")
        currentMission.success = false
        game.failedMissionCount = game.failedMissionCount + 1
      } else {
        println("MAIN BRAIN: Mission Succeeded!!!")
        currentMission.success = true
        game.passedMissionCount = game.passedMissionCount + 1
      }
      
      currentMissionOutcomeVotes.removeAll(keepCapacity: true)
      
      for player in game.players {
        
        player.currentVote = nil
        player.isNominated = false
      }
        
      revealMissionOutcome()
      }
  }
  
    
  func revealMissionOutcome() {
    //Reveals if the mission is successful or fails
    println("MAIN BRAIN: Sending *Reveal Mission Outcome* event to peers.")
    
    var currentMission = game.missions[game.currentMission] as Mission
    println("MAIN BRAIN: Updating mission number index.")
    
    self.changeLeader()
    game.currentMission = game.currentMission + 1

    game.currentGameState = GameEvent.RevealMissionOutcome
    multipeerController.sendEventToPeers(game)
    //Game Controller will go to endgame if failed/succeeded missions are more than 3, or to next mission
  
  }
  
  func endMission() {
    //Memorialize mission information, call updateScore, reset mission timer
    
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
  
  //
  // MARK - Multipeer Delegate Methods
  //
  
  func handleEvent(event: NSMutableDictionary) {
    println(event.description)
    let action  = event["action"] as String
    let peerID  = event["peerID"] as String
    
    switch action {
      
    case "vote" :
      println("MAIN BRAIN: Received vote information from \(peerID)")
      let value = event["value"] as String
      self.tabulateVotes(forPlayer: peerID, andVote: value)
      
    case "missionOutcome" :
      println("MAIN BRAIN: Received mission outcome information from \(peerID)")
      let value = event["value"] as String
      self.tabulateMissionOutcome(forPlayer: peerID, andOutcome: value)
      
    case "user" :
      println("MAIN BRAIN: Received user information from \(peerID)")
      let value = event["value"] as UserInfo
      usersForGame.append(value)
      
    case "nominations" :
      println("MAIN BRAIN: Received nomination information from \(peerID)")
      let value = event["value"] as [String]
      self.assignNominations(value)
      
    default:
      println("MAIN BRAIN: LeadGameController event handler action not recognized.")
      
    }
  }
  
  func assignNominations(arrayOfNominatedPlayerIDs : [String]) {
    
    println("MAIN BRAIN: Got nomination info with these players nominated: \(arrayOfNominatedPlayerIDs.description)")
    
    let currentMission = game.missions[game.currentMission] as Mission
    for player in game.players {
      for nominationID in arrayOfNominatedPlayerIDs {
        println("MAIN BRAIN: Comparing \(nominationID) to \(player.peerID)")
        if nominationID == player.peerID {
          println("MAIN BRAIN: Added \(player.playerName) to mission # \(game.currentMission)'s nominatedPlayer array.")
          currentMission.nominatedPlayers.append(player)
        }
      }
    }
    self.revealNominations()
  }

  func handleEvent(event: GameSession) {
    println("MAIN BRAIN: Something went wrong. This should not be called.")
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
  
  func loadFlavorTextIntoArray() {
    flavorTextArray.append(("Pure Water","The government is seeding the water supply with drugs to control the population. Defeat the grid security to stop the flow of mood alterants."))
    flavorTextArray.append(("LOLLOLLOL","The comedy program Night Time Live broadcasts tonight. Rewrite the teleprompter jokes to become critical of the government as they perform live on air."))
    flavorTextArray.append(("Get Lost","The Secretary for Culture’s motorcade is on the move. Defeat the satellite uplink to hack their GPS and reroute the motorcade to a waiting capture team."))
    flavorTextArray.append(("Higher Education","Hijack the internal security camera feed from a secret reeducation camp and reroute the signal to replace the nightly celebrity report."))
    flavorTextArray.append(("A Percentage","The Wealth Exchange market systems have recently upgraded their network and they are now vulnerable. Hack in and redistribute assets to the poor."))
    flavorTextArray.append(("Blind Justice","This week’s mass execution includes key opposition leaders. Activate prison fire suppression systems to provide cover to an extraction team."))
    flavorTextArray.append(("Musical Chairs","The music played in all public spaces contains subliminal messages supporting the state. Turn up the volume on the messages so the populace knows what's up."))
    flavorTextArray.append(("Voting Record","The electronic voting system changes votes to maintain the status quo. Change the algorithm to favor the opposition cause."))
//    flavorTextArray.append(("",""))
//    flavorTextArray.append(("",""))
//    flavorTextArray.append(("",""))
    
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
  
  func sendUserInfo() {
    println("Not doing anything!")
  }
  
}
