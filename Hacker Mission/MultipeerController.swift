//
//  ViewController.swift
//  MultiPeer Experiment
//
//  Created by Cameron Klein on 10/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import MultipeerConnectivity

class MultiPeerController: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
  
  class var sharedInstance : MultiPeerController {
    struct Static {
      static let instance : MultiPeerController = MultiPeerController()
    }
    return Static.instance
  }
  
  var peerID              : MCPeerID!
  var session             : MCSession!
  var advertiser          : MCNearbyServiceAdvertiser!
  var browser             : MCNearbyServiceBrowser!
  var peerWithMainBrain   : MCPeerID!
  var gameController      : GameController!
  var mainBrain           : LeadGameController?
  
  let MyServiceType = "cf-hacker"
  
  
  override init() {
    super.init()
    
    println("Multipeer Controller Loaded")
    
    let randomNumber = Int(arc4random_uniform(UInt32(10000)))
    
    peerID  = MCPeerID(displayName: UIDevice.currentDevice().name + randomNumber.description)
    
    session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    session.delegate = self
    
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: MyServiceType)
    advertiser.delegate = self
    
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MyServiceType)
    browser.delegate = self
    
    
  }
  
  // MARK: - MCSessionDelegate Methods

  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    println("Received Data!")
    var error : NSError?

    if let gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameSession {
      println("Recognized data as GameSession.")
      gameController.handleEvent(gameData)
    }
      
    else if let dataReceivedFromSlave = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary{
      println("Recognized data as NSDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      
      self.mainBrain?.handleEvent(newDictionary)
      
    } else if let dataReceivedFromSlave = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableDictionary{
      println("Recognized data as NSMutableDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      
      self.mainBrain?.handleEvent(newDictionary)
    }
    else {
      println("Unknown Data Received!")
    }
    
  }
 
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    
    if state == MCSessionState.Connected {
      println("\(peerID.displayName) Connected")
      self.gameController.sendUserInfo()
      self.gameController.updatePeerCount(session.connectedPeers.count)

    } else if state == MCSessionState.NotConnected {
      println("Peer Stopped Connecting")

    } else if state == MCSessionState.Connecting {
      println("Peer Connecting")
    }
    
  }
  
  func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    
    println("Received Stream!")
    
  }
  
  func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    
    println("Started Receiving Resource")
    
  }
  
  func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    println("Got Resource")
  }
  
  // MARK: - MCNearbyServiceAdvertiserDelegate Methods
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
    
    println("Found Main Brain at peer \(peerID.displayName)")
    peerWithMainBrain = peerID
    
    println("Got an invitation and auto-accepting.")
    invitationHandler(true, self.session)
  }
  
  // MARK: - MCNearbyServiceBrowserDelegate Methods
  
  func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
    
    println("Found peer with id \(peerID.displayName). Inviting!")
    browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
    
  }
  
  func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
    
    println("Browser lost peer!")
    
  }
  
  // MARK: - Helper Methods
  
  func startBrowsing() {
    println("Started Browsing!")
    browser.startBrowsingForPeers()
  }
  
  func startAdvertising() {
    println("Started Advertising!")
    advertiser.startAdvertisingPeer()
  }
  
  func stopBrowsing() {
    println("Stopped Browsing!")
    browser.stopBrowsingForPeers()
  }
  
  func stopAdvertising() {
    println("Stopped Advertising!")
    advertiser.stopAdvertisingPeer()
  }
  
  func sendEventToPeers(game: GameSession) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(game)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when sending game to peers: \(error!.description))")
    }
    gameController.handleEvent(game)
  }
  
  func sendInfoToMainBrain(dictionary: NSMutableDictionary) {
    
    let data = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
    var error : NSError?
    if peerWithMainBrain != nil {
      session.sendData(data, toPeers: [peerWithMainBrain], withMode: MCSessionSendDataMode.Reliable, error: &error)
    }
    if error != nil {
      println("Error encountered when sending info to main brain: \(error!.description))")
    }
    dictionary.setObject(self.peerID.displayName, forKey: "peerID")
    self.mainBrain?.handleEvent(dictionary)
    
  }
    
  func sendUserInfoToLeadController(userInfo: UserInfo){
    
    userInfo.userPeerID = self.peerID.displayName
    let dictionaryData = ["action" : "user", "value" : userInfo]
    let data = NSKeyedArchiver.archivedDataWithRootObject(dictionaryData)
    var error : NSError?
    if peerWithMainBrain != nil {
      session.sendData(data, toPeers: [peerWithMainBrain], withMode: MCSessionSendDataMode.Reliable, error: &error)
    }
    if error != nil {
      println("Error encountered when sending user info to main brain: \(error!.description))")
    }
    
  }

}



