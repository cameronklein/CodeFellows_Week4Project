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
  var disconnectedPeers   = [MCPeerID]()
  var gameRunning         = false
  
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
    println("Received Data!")
    var error : NSError?

    if let gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameSession {
      println("Recognized data as GameSession.")
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.gameController.handleEvent(gameData)
        return ()
      }
    }

    else if let imagePackets = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [ImagePacket] {
      println("Recognized data as ImagePacket aray.")
      gameController.handleImagePackets(imagePackets)
    }
      
    else if let dataReceivedFromSlave = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary{
      println("Recognized data as NSDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.mainBrain?.handleEvent(newDictionary)
        return ()
      }
      
    } else if let dataReceivedFromSlave = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableDictionary{
      println("Recognized data as NSMutableDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("value")!, forKey: "value")
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
    }
    else {
      println("Unknown Data Received!")
    }
    
  }

  // MARK: HEREEEEEE!!!!!
 
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    
    if state == MCSessionState.Connected {
      println("\(peerID.displayName) Connected")
      self.gameController.sendUserInfo()
      self.gameController.updatePeerCount(session.connectedPeers.count)
      self.gameController.sendImagePacket() // This may need an acknowledgement from the server, but I want to chase that later

    } else if state == MCSessionState.NotConnected {
      println("Peer \(peerID.displayName) Stopped Connecting")
      if mainBrain != nil {
        println("MAIN BRAIN: Adding \(peerID.displayName) to disconnected peers list.")
        self.disconnectedPeers.append(peerID)
        self.startBrowsing()
      }

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
      for peer in disconnectedPeers {
        if peer.displayName == peerID.displayName {
        println("Found previously connected peer with id \(peerID.displayName). Inviting!")
         browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
        }
      }
    } else if gameRunning == false {
      println("Found new peer with id \(peerID.displayName). Inviting!")
      browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
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

  // MARK: HERE

  func sendEventToPeers(game: GameSession) { // copy this!!!!!!!!!!!!!!
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
  
  func resendGameInfoToPeer(peerID : MCPeerID) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(mainBrain!.game)
    var error : NSError?
    session.sendData(data, toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println("Error encountered when resending game to peer: \(error!.description))")
    }

  }


  func sendImagePacketToLeadController(userInfo: UserInfo){

    let myPeerID = self.peerID.displayName as NSString
    let imageFor = userInfo.userImage as UIImage!
    let imagePacket = ImagePacket(peerID: myPeerID, userImage: imageFor)

    let dictionaryData = ["action" : "imagePacket", "value" : imagePacket]
    let data = NSKeyedArchiver.archivedDataWithRootObject(dictionaryData)
    var error : NSError?
    if peerWithMainBrain != nil {
      session.sendData(data, toPeers: [peerWithMainBrain], withMode: MCSessionSendDataMode.Reliable, error: &error)
    }
    if error != nil {
      println("Error encountered when sending user info to main brain: \(error!.description))")
    }

  }

} // End



