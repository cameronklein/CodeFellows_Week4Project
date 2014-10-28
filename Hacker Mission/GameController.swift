//
//  GameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation

class GameController : NSObject, MultiPeerDelegate {
  
  var game : GameSession!
  var homeVC : HomeViewController!
  var multipeerController = MultiPeerController.sharedInstance
  
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
    multipeerController.startAdvertising()
  }
  
  func gameStart() {
    
  }
  
  func revealCharacters() {
    //At start of game reveal what role you are in the game
//    self.homeVC.revealCharacters(game.playerList)

  }
  
  func nominatePlayers() {
    //Leader nominates their team of players
//    self.homeVC.nominatePlayersForMission(game.missionList[currentMissionIndex])

  }
  
  func revealNominations() {
    
  }
  
  func startMission() {
    
  }
  
  func vote() {
    //Vote on proposed team
//    self.homeVC.voteOnProposedTeam()
  }
  
  func revealVotes() {
    //reveal everyone's vote on the proposed team
//    self.homeVC.revealVotes()
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


}
