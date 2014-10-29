//
//  GameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

class GameController : MultiPeerDelegate {
  
  var game : GameSession!
  var homeVC : HomeViewController!
  var multipeerController = MultiPeerController.sharedInstance
  var peerCount : Int = 0
    var userInfo : UserInfo?
  var myUserInfo = UserInfo(userName: "Teddy Roosevelt")
  
  init(){
    multipeerController.delegate = self

  }
  
  func handleEvent(event: GameEvent) {
    println("Received \(event.rawValue) event from Main Brain. Woot.")
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
    //case .Vote:
      //self.vote()
    case .RevealVote:
      self.revealVotes()
    case .BeginMissionOutcome:
      self.beginMissionOutcome()
    case .RevealMissionOutcome:
      self.revealMissionOutcome()
    case .End:
      self.endGame()
    default:
        println("Unknown")
    }
  }
  
  func startLookingForGame(){
    self.userInfo = UserInfo(userName: "Follower")
    multipeerController.userInfo = self.userInfo
    multipeerController.startAdvertising()
  }
  
  func gameStart() {
    multipeerController.stopAdvertising()
    sendUserInfo()
    
    // TODO: Intro Animation?
    let players = game.players
    for player in players {
      if multipeerController.peerID == player.peerID {
        homeVC.user = player as Player
      }
    }
  }
  
  func revealCharacters() {
    //At start of game reveal what role you are in the game
    
    //self.homeVC.revealCharacters(game.playerList)

  }
  
  func nominatePlayers() {
    //Leader nominates their team of players
//    self.homeVC.nominatePlayersForMission(game.missionList[currentMissionIndex])

  }
  
  func revealNominations() {
//    self.homeVC.voteOnProposedTeam(game)
  }
  
  func revealVotes() {
    //reveal everyone's vote on the proposed team
//    self.homeVC.revealVotes()
  }
  
  func startMission() {
    // TODO: Intro Animation?
  }
  
  func beginMissionOutcome() {
    //Nominated players on mission vote to succeed or fail the mission
//    self.homeVC.voteOnMissionSuccess()

  }
  
  func revealMissionOutcome() {
    //revealing the success/fail votes
//    self.homeVC.revealMissionOutcome()
  }
  
  func endGame() {
    
  }

  func handleEvent(event: NSMutableDictionary) {
    println("Two")
  }


    func updatePeerCount(count : Int) {
        self.peerCount = count
        if let root = UIApplication.sharedApplication().keyWindow?.rootViewController as? LaunchViewController {
            root.updateConnectedPeersLabel(count)
        }
        sendUserInfo()
    }
    func sendUserInfo () {
     multipeerController.sendUserInfoToLeadController(userInfo!)
    }

}
