//
//  GameController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

class GameController {
  
  class var sharedInstance : GameController {
    struct Static {
      static let instance : GameController = GameController()
    }
    return Static.instance
  }
  
  var game        : GameSession!  //Authoritative list of players is here at all times.
  var revealVC    : RevealViewController!
  var launchVC    : LaunchViewController!
  var homeVC      : HomeViewController!
  var userInfo    : UserInfo?
  var myUserInfo  : UserInfo!
  var thisPlayer  : Player!
  var peerCount   : Int = 0
  
  var multipeerController = MultiPeerController.sharedInstance
  var imagePackets = [ImagePacket]()
  
  init(){
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    multipeerController.gameController = self
    myUserInfo = appDelegate.defaultUser as UserInfo!
    myUserInfo.userPeerID = multipeerController.peerID.displayName

  }

  func handleImagePackets(imagePackets: [ImagePacket]) {
    self.imagePackets = imagePackets as [ImagePacket]
  }
  
  func handleEvent(newGameInfo: GameSession) {
    self.game = newGameInfo
    let event = game.currentGameState!
    if event != .Start || event != .RevealCharacters {
      findMe()
    }
    println("GAME CONTROLLER: Received \(event.rawValue) event from Main Brain. Woot.")
    switch event{
    case .Start:
      self.gameStart()
    case .NominatePlayers:
      self.nominatePlayers()
    case .RevealNominations:
      self.revealNominations()
    case .MissionStart:
      self.startMission()
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
  
  func findMe(){
    for player in game.players {
      if player.peerID == multipeerController.peerID.displayName {
        self.thisPlayer = player
      }
    }
  }
  
  func startLookingForGame(){
    
    multipeerController.startAdvertising()
    
  }
  
  func gameStart() {
    
    println("GAME CONTROLLER: Got Game Start Message")
    
    multipeerController.stopAdvertising()
    revealVC = RevealViewController(nibName: "RevealViewController", bundle: NSBundle.mainBundle())
    
    self.launchVC.gameStart(revealVC)
    
  }
  
  func nominatePlayers() {
    //Leader nominates their team of players
    self.homeVC.nominatePlayers()

  }
  
  func revealNominations() {
    
    self.homeVC.voteOnProposedTeam()
  }
  
  func revealVotes() {
    //reveal everyone's vote on the proposed team
    self.homeVC.revealVotes()
  }
  
  func startMission() {
    // TODO: Intro Animation?
    self.homeVC.startMission()
  }
  
  func beginMissionOutcome() {
    println("GAME CONTROLLER: Begin Mission Outcome call sent to HomeViewController")
    //Nominated players on mission vote to succeed or fail the mission
    self.homeVC.voteOnMissionSuccess()

  }
  
  func revealMissionOutcome() {
    //revealing the success/fail votes
    self.homeVC.revealMissionOutcome()
  }
  
  func endGame() {
    
  }

  func updatePeerCount(count : Int) {
    self.peerCount = count
    if let root = UIApplication.sharedApplication().keyWindow?.rootViewController as? LaunchViewController {
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        root.updateConnectedPeersLabel(count)
      })
    }
  }
  
  func sendUserInfo () {
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    if let thisUser = appDel.defaultUser as UserInfo! {
      thisUser.userPeerID = multipeerController.peerID.displayName
      multipeerController.sendUserInfoToLeadController(thisUser)
    }
  }

  func sendImagePacket () {
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    if let thisUser = appDel.defaultUser as UserInfo! {
      thisUser.userPeerID = multipeerController.peerID.displayName
      multipeerController.sendImagePacketToLeadController(thisUser)
    }
  }

} //End
