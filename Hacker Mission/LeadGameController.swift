//
//  LeadGameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

class LeadGameController {
  
  var multipeerController : MultiPeerController = MultiPeerController.sharedInstance
  var game : GameSession!
  var imagePacketsForGame = [ImagePacket]()
  var currentVotes = [String]()
  var currentMissionOutcomeVotes = [String]()
  var usersForGame = [UserInfo]()
  var peerCount : Int = 0
  var myUserInfo : UserInfo!
  var launchVC : LaunchViewController!
  var flavorTextArray = [[String: String]]()
  var logFor = LogClass()


  var requestQueue = NSOperationQueue()
  
  init() {
    multipeerController.mainBrain = self
    self.loadFlavorTextIntoArray()
    requestQueue.maxConcurrentOperationCount = 1
  }
  
  func startLookingForPlayers() {
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    if let thisUser = appDel.defaultUser as UserInfo! {
      logFor.DLog("thisUser is \(thisUser)")
      thisUser.userPeerID = multipeerController.peerID.displayName
      usersForGame.append(thisUser)
      imagePacketsForGame.append(ImagePacket(peerID: thisUser.userPeerID!, userImage: thisUser.userImage!))
    }
    multipeerController.startBrowsing()
  }
  
  func beginRequestingImagesFromPlayers() {
    multipeerController.showLoadingScreen(0.0)
    self.requestImagesFromPlayers()
  }
  
  func requestImagesFromPlayers() {
    let percentage : Float = Float(self.imagePacketsForGame.count) / Float(self.usersForGame.count)
    self.multipeerController.showLoadingScreen(percentage)
    requestQueue.addOperationWithBlock { () -> Void in
      if self.imagePacketsForGame.count == self.usersForGame.count {
        self.startGame()
      } else {
        for user in self.usersForGame {
          var packetArrayHasImage = false
          for packet in self.imagePacketsForGame {
            if packet.userPeerID == user.userPeerID {
              packetArrayHasImage = true
            }
          }
          if packetArrayHasImage == false {
            self.logFor.DLog("Asking for image from \(user.userPeerID!)")
            self.requestQueue.addOperationWithBlock({ () -> Void in
              NSThread.sleepForTimeInterval(3.0)
              self.multipeerController.requestImageFromPeer(user.userPeerID!)
            })
            break
          }
        }
        self.requestImagesFromPlayers()
      }
    }
  }
  
  func startGame() {
    
    logFor.DLog("MAIN BRAIN : Start Game Function Called")
    multipeerController.gameRunning = true
    
    //multipeerController.stopBrowsing()
  
    let players = self.getPlayersFromCurrentUsersArray()

    logFor.DLog("MAIN BRAIN: \(players.count) players created from provided user information.")
    
    multipeerController.sendImagePacketsToPeers(imagePacketsForGame)
    
    var missions = GameSession.populateMissionList(players.count)
    
    self.giveFlavorTextToMissions(&missions)
    
    logFor.DLog("MAIN BRAIN: Created \(missions.count) missions.")
    
    self.game = GameSession(players: players, missions: missions)
    
    if self.game != nil {
      logFor.DLog("MAIN BRAIN: Game Created. We are ready for launch.")
      self.assignRoles()
    }
    
    let revealVC = RevealViewController(nibName: "RevealViewController", bundle: NSBundle.mainBundle())
    GameController.sharedInstance.revealVC = revealVC
    
    self.launchVC.gameStart(revealVC)
    }
  
  func getPlayersFromCurrentUsersArray() -> [Player] {
    
    var players = [Player]()
    logFor.DLog("MAIN BRAIN : Creating players from user array of \(usersForGame.count) users.")
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
    logFor.DLog("MAIN BRAIN : Created \(players.count) players.")
    
    return players
  }

  func getImagePacketsFromCurrentUsersArray() -> [ImagePacket] {
    
    var imagePackets = [ImagePacket]()
    logFor.DLog("MAIN BRAIN : Creating imagePackets from user array of \(usersForGame.count) users.")
    for user in usersForGame {

      let imagePacketFor = ImagePacket(peerID: user.userPeerID!, userImage: user.userImage!)

      var needToAdd : Bool = true
      for existingImagePacket in imagePackets {
        if (existingImagePacket.userPeerID == imagePacketFor.userPeerID) {
          needToAdd = false
        }
      }
      if (needToAdd) {
        imagePackets.append(imagePacketFor)
      }
    }
    logFor.DLog("MAIN BRAIN : Created \(imagePackets.count) image packets.")

    return imagePackets
  }

  func giveFlavorTextToMissions(inout missions: [Mission]) {
    
    for mission in missions {
      
      let flavorTextIndex = Int(arc4random_uniform(UInt32(flavorTextArray.count)))
      let missionText = flavorTextArray[flavorTextIndex]
      mission.missionName = missionText["Title"]!
      mission.missionDescription = missionText["Description"]
      flavorTextArray.removeAtIndex(flavorTextIndex)
      
    }
  }

  func assignRoles(){
    logFor.DLog("MAIN BRAIN: Beginning to assign player roles for \(game.players.count) players.")

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
        logFor.DLog("MAIN BRAIN: Assigned \(player.playerName) as Agent.")
        player.playerRole = PlayerType.Agent
        currentAgents++
      }
    }
    
    logFor.DLog("MAIN BRAIN: Assigned \(currentAgents) agents at random.")
    
    let j = Int(arc4random_uniform(UInt32(numberOfPlayers)))
    var player = players[j] as Player
    player.isLeader = true
    game.leader = player
    
    logFor.DLog("MAIN BRAIN: Assigned \(player.playerName) as initial leader.")
    logFor.DLog("MAIN BRAIN: Sending *Game Start* event to peers.")
    game.currentGameState = GameEvent.Start
    multipeerController.sendEventToPeers(game) // first send!!!!!!!!!!!!
    self.revealCharacters()
  }
  
  func revealCharacters() {
    //Sends information on who is on what team (Hackers and Goverment Agents) to devices.  Only Goverment Agents see who the other Goverment Agents are
    logFor.DLog("MAIN BRAIN: Sending *Reveal Characters* event to peers.")
    for player in game.players {
      
      player.currentVote = nil
      player.isNominated = false
    }
    game.currentGameState = GameEvent.RevealCharacters
    multipeerController.sendEventToPeers(game)

  }

  func changeLeader() {
    //Assigns a leader for current mission and itterates through all players, per games rules, and gives them a chance to be leader.
//    var leaderIndex = game.players.indexOfObject(game.leader!)
    logFor.DLog("MAIN BRAIN: Changing leader. Was \(game.leader!.playerName)")
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
    logFor.DLog("MAIN BRAIN: New leader is \(game.leader!.playerName)")
  }

  func startMission() {
    //Calculates how many hackers will go on a mission, and how many failures it requires for the mission to fail
    logFor.DLog("MAIN BRAIN: Sending *Mission Start* event to peers.")
    game.currentGameState = GameEvent.MissionStart
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellLeaderToNominatePlayers() {
    //Leader nominates the appropriate number of hackers to go on the mission
    logFor.DLog("MAIN BRAIN: Sending *Nominate Players* event to peers.")
    for player in game.players {
      
      player.currentVote = nil
      player.isNominated = false
    }
    
    game.currentGameState = GameEvent.NominatePlayers
    multipeerController.sendEventToPeers(game)
    
  }
  
  func revealNominations() {
    //Leader locks in their nominated team for the mission
    logFor.DLog("MAIN BRAIN: Sending *Reveal Nominations* event to peers.")
    game.currentGameState = GameEvent.RevealNominations
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tellPlayersToVote() {
    //All players vote to approve or reject the nominated team for the mission
    logFor.DLog("MAIN BRAIN: Sending *Begin Vote* event to peers.")
    game.currentGameState = GameEvent.BeginVote
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateVotes(forPlayer playerID : String, andVote voteResult : String) {
    
    //Calculates if the mission is approved or rejected
    logFor.DLog("MAIN BRAIN: Vote receieved from \(playerID).")
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
      logFor.DLog("MAIN BRAIN: Last vote received. Deciding winner...")
      logFor.DLog(currentVotes.description)
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
        logFor.DLog("MAIN BRAIN: Team REJECTED by players. (Approved: \(approved). Rejected: \(rejected).")
        let mission = game.missions[game.currentMission] as Mission
        mission.rejectedTeamsCount =  mission.rejectedTeamsCount + 1
      } else {
        logFor.DLog("MAIN BRAIN: Team APPROVED by players. (Approved: \(approved). Rejected: \(rejected).")
        didPass = true
      }
      currentVotes.removeAll(keepCapacity: true)      //Reset currentVotes
      self.revealVotes(didPass)
    }
  }
  
  func revealVotes(passed: Bool) {
    
    //Displays all players votes to approve/reject the mission
    logFor.DLog("MAIN BRAIN: Sending *Reveal Vote* event to peers.")
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
      
      logFor.DLog("MAIN BRAIN: Telling nominated players to determine mission outcome! Nominated players: \(currentMission.nominatedPlayers.description)")
      
      self.delay(10.0, closure: { () -> () in
       self.tellPlayersToDetermineMissionOutcome()
      })
    }
  }
  
  func tellPlayersToDetermineMissionOutcome() {
    //Nominated hackers vote if the mission will Succeed or Fail
    logFor.DLog("MAIN BRAIN: Sending *Begin Mission Outcome* event to peers.")
    game.currentGameState = GameEvent.BeginMissionOutcome
    multipeerController.sendEventToPeers(game)
    
  }
  
  func tabulateMissionOutcome(forPlayer playerID : String, andOutcome outcome: String) {
    //Calculate if the mission will succeed or fail, based on mission criteria
    
    logFor.DLog("MAIN BRAIN: Mission outcome vote received from \(playerID)")
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
        logFor.DLog("MAIN BRAIN: Mission Failed!!!")
        currentMission.success = false
        game.failedMissionCount = game.failedMissionCount + 1
      } else {
        logFor.DLog("MAIN BRAIN: Mission Succeeded!!!")
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
    logFor.DLog("MAIN BRAIN: Sending *Reveal Mission Outcome* event to peers.")
    
    var currentMission = game.missions[game.currentMission] as Mission
    logFor.DLog("MAIN BRAIN: Updating mission number index.")
    
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
    logFor.DLog(event.description)
    let action  = event["action"] as String
    let peerID  = event["peerID"] as String
    
    switch action {
      
    case "vote" :
      logFor.DLog("MAIN BRAIN: Received vote information from \(peerID)")
      let value = event["value"] as String
      self.tabulateVotes(forPlayer: peerID, andVote: value)
      
    case "missionOutcome" :
      logFor.DLog("MAIN BRAIN: Received mission outcome information from \(peerID)")
      let value = event["value"] as String
      self.tabulateMissionOutcome(forPlayer: peerID, andOutcome: value)
      
    case "user" :
      logFor.DLog("MAIN BRAIN: Received user information from \(peerID)")
      let value = event["value"] as String
      let user = UserInfo(userName: value)
      user.userPeerID = peerID
      usersForGame.append(user)
      // MARK: FInish this with a new event to request the imagePackets

    case "imagePacket" :
      logFor.DLog("MAIN BRAIN: Received imagePacket from \(peerID)")
      let image = event["value"] as UIImage
      imagePacketsForGame.append(ImagePacket(peerID: peerID, userImage: image))

    case "nominations" :
      logFor.DLog("MAIN BRAIN: Received nomination information from \(peerID)")
      let value = event["value"] as [String]
      self.assignNominations(value)
      
    default:
      logFor.DLog("MAIN BRAIN: LeadGameController event handler action not recognized.")
      
    }
  }
  
  func assignNominations(arrayOfNominatedPlayerIDs : [String]) {
    
    logFor.DLog("MAIN BRAIN: Got nomination info with these players nominated: \(arrayOfNominatedPlayerIDs.description)")
    
    let currentMission = game.missions[game.currentMission] as Mission
    for player in game.players {
      for nominationID in arrayOfNominatedPlayerIDs {
        logFor.DLog("MAIN BRAIN: Comparing \(nominationID) to \(player.peerID)")
        if nominationID == player.peerID {
          logFor.DLog("MAIN BRAIN: Added \(player.playerName) to mission # \(game.currentMission)'s nominatedPlayer array.")
          currentMission.nominatedPlayers.append(player)
        }
      }
    }
    self.revealNominations()
  }

  func handleEvent(event: GameSession) {
    logFor.DLog("MAIN BRAIN: Something went wrong. This should not be called.")
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
    
    let flavorTextPath = NSBundle.mainBundle().pathForResource("FlavorText", ofType: "plist")
    let flavorTextDict = NSDictionary(contentsOfFile: flavorTextPath!)
    flavorTextArray = flavorTextDict!["Mission"] as [[String : String]]

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
    logFor.DLog("Not doing anything!")
  }
  
  func resetForNewGame() {
    var peerCount : Int = 0
    var imagePacketsForGame = [ImagePacket]()
    var currentVotes = [String]()
    var currentMissionOutcomeVotes = [String]()
    var flavorTextArray = [[String: String]]()
  }
}
