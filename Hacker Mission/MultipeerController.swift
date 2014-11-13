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
  var logFor              = LogClass()


  let MyServiceType = "cf-hacker"
  
  
  override init() {
    super.init()
    
    logFor.DLog("Multipeer Controller Loaded")
    
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
    logFor.DLog("Received data from \(peerID.displayName)")
      
    var error : NSError?

    if let gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameSession {
      logFor.DLog("Recognized data as GameSession.")
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.gameController.handleEvent(gameData)
        return ()
      }
  
    } else if let imagePackets = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [ImagePacket] {
      logFor.DLog("Recognized data as ImagePacket aray.")
      gameController.handleImagePackets(imagePackets)
    
    } else if let userImage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? UIImage {
      logFor.DLog("Recognized data as UIImage.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject("imagePacket", forKey: "action")
      newDictionary.setObject(userImage, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.mainBrain?.handleEvent(newDictionary)
        return ()
      }
      
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary{
      logFor.DLog("Recognized data as NSDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceived.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceived.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.mainBrain?.handleEvent(newDictionary)
        return ()
      }
      
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableDictionary{
      logFor.DLog("Recognized data as NSMutableDictionary.")
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
      logFor.DLog("Recognized data as String: \(dataReceived)")
      
      if dataReceived == "RequestImage" {
        self.gameController.sendImagePacket()
      }
    } else if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Float {
      logFor.DLog("Recognized data as Float: \(dataReceived)")
      
      self.gameController.showLoadingScreen(dataReceived)
      
    }
      
    else {
      logFor.DLog("Unknown Data Received!")
    }
    
  }
 
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    
    if state == MCSessionState.Connected {
      logFor.DLog("\(peerID.displayName) Connected")
      if self.didSendUserData == false {
        self.gameController.sendUserInfo()
        self.didSendUserData = true
      }
      self.gameController.updatePeerCount(session.connectedPeers.count)

    } else if state == MCSessionState.NotConnected {
      logFor.DLog("Peer \(peerID.displayName) Stopped Connecting")

    } else if state == MCSessionState.Connecting {
      logFor.DLog("Peer Connecting")
    }
    
  }
  
  func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {

    logFor.DLog("Received Stream!")
    
  }
  
  func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    
    logFor.DLog("Started Receiving Resource")
    
  }
  
  func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    logFor.DLog("Got Resource")
  }
  
  // MARK: - MCNearbyServiceAdvertiserDelegate Methods
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
    
    logFor.DLog("Found Main Brain at peer \(peerID.displayName)")
    peerWithMainBrain = peerID
    
    logFor.DLog("Got an invitation and auto-accepting.")
    invitationHandler(true, self.session)
  }
  
  // MARK: - MCNearbyServiceBrowserDelegate Methods
  
  func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
    logFor.DLog("Found peer!")
    if gameRunning == true {
      for peer in peersForCurrentGame {
        if peer.displayName == peerID.displayName {
        logFor.DLog("Found previously connected peer with id \(peerID.displayName). Inviting!")
         browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
        }
      }
    } else if gameRunning == false {
      logFor.DLog("Found new peer with id \(peerID.displayName). Inviting!")
      browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
      peersForCurrentGame.append(peerID)
    }
  }
  
  func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
    
    logFor.DLog("Browser lost peer!")
    
  }
  
  // MARK: - Helper Methods
  
  func startBrowsing() {
    logFor.DLog("Started Browsing!")
    browser.startBrowsingForPeers()
  }
  
  func startAdvertising() {
    logFor.DLog("Started Advertising!")
    advertiser.startAdvertisingPeer()
  }
  
  func stopBrowsing() {
    logFor.DLog("Stopped Browsing!")
    browser.stopBrowsingForPeers()
  }
  
  func stopAdvertising() {
    logFor.DLog("Stopped Advertising!")
    advertiser.stopAdvertisingPeer()
  }

  // MARK: - Helper Methods

  func sendEventToPeers(game: GameSession) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(game)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      logFor.DLog("Error encountered when sending game to peers: \(error!.description))")
    }
    gameController.handleEvent(game)
  }

  func sendImagePacketsToPeers(imagePackets: [ImagePacket]) {
    logFor.DLog("Sending image packets to peers")
    let data = NSKeyedArchiver.archivedDataWithRootObject(imagePackets)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      logFor.DLog("Error encountered when sending game to peers: \(error!.description))")
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
      logFor.DLog("Error encountered when sending info to main brain: \(error!.description))")
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
      logFor.DLog("Error encountered when sending user info to main brain: \(error!.description))")
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
      logFor.DLog("Error encountered when resending game to peer: \(error!.description))")
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
      logFor.DLog("Error encountered when resending game to peer: \(error!.description))")
    }

  }
  
  func showLoadingScreen(percentage: Float){
    let data = NSKeyedArchiver.archivedDataWithRootObject(percentage)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      logFor.DLog("Error encountered when resending game to peer: \(error!.description))")
    }
    self.gameController.showLoadingScreen(percentage)
  }

  func sendImagePacketToLeadController(image: UIImage){
    logFor.DLog("Sending image packet to Main Brain!")
    let data = NSKeyedArchiver.archivedDataWithRootObject(image)
    var error : NSError?
    if didSendImagePacket == false {
      didSendImagePacket = true
      if peerWithMainBrain != nil {
        session.sendData(data, toPeers: [peerWithMainBrain], withMode: MCSessionSendDataMode.Reliable, error: &error)
      }
    }
    if error != nil {
      logFor.DLog("Error encountered when sending user info to main brain: \(error!.description))")
    }
  }
  
  func resetForNewGame(){
    self.mainBrain = nil
    peersForCurrentGame = [MCPeerID]()
    gameRunning         = false
    didSendUserData     = false
    didSendImagePacket  = false
    session.disconnect()
    session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
  }

} // End



