//
//  MultiPeerController.swift
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
  var peersForCurrentGame = [MCPeerID]()
  var gameRunning         = false
  var didSendUserData     = false
  var didSendImagePacket  = false
  
  let MyServiceType = "cf-hacker"
  
  
  override init() {
    super.init()
    
    println("Multipeer Controller Loaded")
    
    if let savedName = NSUserDefaults.standardUserDefaults().objectForKey("PeerDisplayName") as? String {
      peerID  = MCPeerID(displayName: savedName)
    } else {
      let randomNumber = Int(arc4random_uniform(UInt32(10000)))
      peerID  = MCPeerID(displayName: UIDevice.currentDevice().name + randomNumber.description)
      NSUserDefaults.standardUserDefaults().setObject(NSString(string: peerID.displayName!), forKey: "PeerDisplayName")
      NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    session.delegate = self
    
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: MyServiceType)
    advertiser.delegate = self
    
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MyServiceType)
    browser.delegate = self
  
  }
  
  // MARK: - MCSessionDelegate Methods

  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    println("Received data from \(peerID.displayName)")
      
    var error : NSError?

    if let gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameSession {
      println("Recognized data as GameSession.")
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.gameController.handleEvent(gameData)
        return ()
      }
  
    } else if let imagePackets = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [ImagePacket] {
      println("Recognized data as ImagePacket aray.")
      gameController.handleImagePackets(imagePackets)
    
    } else if let userImage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? UIImage {
      println("Recognized data as UIImage.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject("imagePacket", forKey: "action")
      newDictionary.setObject(userImage, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.mainBrain?.handleEvent(newDictionary)
        return ()
      }
      
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary{
      println("Recognized data as NSDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceived.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceived.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.mainBrain?.handleEvent(newDictionary)
        return ()
      }
      
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableDictionary{
      println("Recognized data as NSMutableDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceived.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceived.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      
      let checkForGameRequestString = newDictionary.objectForKey("action") as String!
      
      if checkForGameRequestString == "gameRequest" {
        if mainBrain != nil {
          self.resendGameInfoToPeer(peerID)
        }
      }
      
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.mainBrain?.handleEvent(newDictionary)
        return ()
      }
      
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
      println("Recognized data as String: \(dataReceived)")
      
      if dataReceived == "RequestImage" {
        self.gameController.sendImagePacket()
      }
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Float {
      println("Recognized data as Float: \(dataReceived)")
      
      self.gameController.showLoadingScreen(dataReceived)
      
    }
      
    else {
      println("Unknown Data Received!")
    }
    
  }
 
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    
    if state == MCSessionState.Connected {
      println("\(peerID.displayName) Connected")
      if self.didSendUserData == false {
        self.gameController.sendUserInfo()
        self.didSendUserData = true
      }
      self.gameController.updatePeerCount(session.connectedPeers.count)

    } else if state == MCSessionState.NotConnected {
      println("Peer \(peerID.displayName) Stopped Connecting")

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
    
    if gameRunning == true {
      for peer in peersForCurrentGame {
        if peer.displayName == peerID.displayName {
        println("Found previously connected peer with id \(peerID.displayName). Inviting!")
         browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
        }
      }
    } else if gameRunning == false {
      println("Found new peer with id \(peerID.displayName). Inviting!")
      browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
      peersForCurrentGame.append(peerID)
    }
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

  // MARK: - Helper Methods

  func sendEventToPeers(game: GameSession) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(game)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when sending game to peers: \(error!.description))")
    }
    gameController.handleEvent(game)
  }

  func sendImagePacketsToPeers(imagePackets: [ImagePacket]) {
    println("Sending image packets to peers")
    let data = NSKeyedArchiver.archivedDataWithRootObject(imagePackets)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when sending game to peers: \(error!.description))")
    }
    gameController.handleImagePackets(imagePackets)
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

    let myPeerID = self.peerID.displayName as NSString
    userInfo.userPeerID = myPeerID

    let dictionaryData = ["action" : "user", "value" : userInfo.userName]
    let data = NSKeyedArchiver.archivedDataWithRootObject(dictionaryData)
    var error : NSError?
    if peerWithMainBrain != nil {
      session.sendData(data, toPeers: [peerWithMainBrain], withMode: MCSessionSendDataMode.Reliable, error: &error)
    }
    if error != nil {
      println("Error encountered when sending user info to main brain: \(error!.description))")
    }
    
  }
  
  func resendGameInfoToPeer(peerID : MCPeerID) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(mainBrain!.game)
    let imageData = NSKeyedArchiver.archivedDataWithRootObject(mainBrain!.imagePacketsForGame)
    var error : NSError?
    session.sendData(data, toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: &error)
    NSThread.sleepForTimeInterval(0.2)
    session.sendData(imageData, toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when resending game to peer: \(error!.description))")
    }
  }
  
  func requestImageFromPeer(peerIDDisplayName: String) {
    let data = NSKeyedArchiver.archivedDataWithRootObject("RequestImage")
    var error : NSError?
    var peerID : MCPeerID!
    for peer in session.connectedPeers {
      if peer.displayName == peerIDDisplayName {
        peerID = peer as MCPeerID
      }
    }
    session.sendData(data, toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when resending game to peer: \(error!.description))")
    }

  }
  
  func showLoadingScreen(percentage: Float){
    let data = NSKeyedArchiver.archivedDataWithRootObject(percentage)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when resending game to peer: \(error!.description))")
    }
    self.gameController.showLoadingScreen(percentage)
  }

  func sendImagePacketToLeadController(image: UIImage){
    println("Sending image packet to Main Brain!")
    let data = NSKeyedArchiver.archivedDataWithRootObject(image)
    var error : NSError?
    if didSendImagePacket == false {
      didSendImagePacket = true
      if peerWithMainBrain != nil {
        session.sendData(data, toPeers: [peerWithMainBrain], withMode: MCSessionSendDataMode.Reliable, error: &error)
      }
    }
    if error != nil {
      println("Error encountered when sending user info to main brain: \(error!.description))")
    }

  }

} // End



