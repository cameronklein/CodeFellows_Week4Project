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
  var revealVC : RevealViewController!
  var launchVC : LaunchViewController!
  var multipeerController = MultiPeerController.sharedInstance
  var peerCount : Int = 0
  var userInfo : UserInfo?
  var myUserInfo : UserInfo!
  
  init(){
    multipeerController.delegate = self
    myUserInfo = UserInfo(userName: "Teddy Roosevelt", userImage: UIImage(named: "AtSymbol")!)
    myUserInfo.userPeerID = multipeerController.peerID.displayName
    myUserInfo.userImage = UIImage(named: "AtSymbol")!
  }
  
  func handleEvent(newGameInfo: GameSession) {
    self.game = newGameInfo
    let event = game.currentGameState!
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
    self.userInfo = UserInfo(userName: "Follower", userImage: UIImage(named: "AtSymbol")!)
    multipeerController.userInfo = self.userInfo
    multipeerController.startAdvertising()
  }
  
  func gameStart() {
    println("Got Game Start Message")
    multipeerController.stopAdvertising()
    revealVC = RevealViewController(nibName: "RevealViewController", bundle: NSBundle.mainBundle())
    // TODO: Intro Animation?
    let players = game.players
    for player in players {
        println("\(multipeerController.peerID.displayName) is from Controller, \(player.peerID) is the local")
      if multipeerController.peerID.displayName == player.peerID {
        println("Entered the If")
        revealVC.user = player as? Player
      }
    }
    
    //    let revealVC = UIStoryboard(name: "Main", bundle:
    //        NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("HOME") as RevealViewController
    revealVC.game = self.game
    
    self.launchVC.gameStart(revealVC)
    
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
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        root.updateConnectedPeersLabel(count)
            //collect userInfo as users join
      })
    }
    sendUserInfo()
  }
    func sendUserInfo () {
     multipeerController.sendUserInfoToLeadController(myUserInfo)
    }

}
