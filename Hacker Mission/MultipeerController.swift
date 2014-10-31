//
//  ViewController.swift
//  MultiPeer Experiment
//
//  Created by Cameron Klein on 10/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import MultipeerConnectivity

protocol MultiPeerDelegate {
  func handleEvent(event : GameSession)
  func handleEvent(event : NSMutableDictionary)
  func updatePeerCount(Int)
}

class MultiPeerController: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
  
  class var sharedInstance : MultiPeerController {
    struct Static {
      static let instance : MultiPeerController = MultiPeerController()
    }
    return Static.instance
  }
  
  var peerID      : MCPeerID!
  var session     : MCSession!
  var advertiser  : MCNearbyServiceAdvertiser!
  var browser     : MCNearbyServiceBrowser!
  var delegate    : MultiPeerDelegate!
  var mainBrainDelegate : MultiPeerDelegate?
  var userInfo    : UserInfo?
  
  let MyServiceType = "cf-hacker"
  
  
  override init() {
    super.init()
    
    println("Multipeer Controller Loaded")
    
    let randomNumber = Int(arc4random_uniform(UInt32(1000)))
    
    peerID  = MCPeerID(displayName: UIDevice.currentDevice().name + randomNumber.description)
    
    session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    session.delegate = self
    
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: MyServiceType)
    advertiser.delegate = self
    
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MyServiceType)
    browser.delegate = self
    //playersForGame = [UserInfo] as NSMutableArray
    
  }
  
  // MARK: - MCSessionDelegate Methods

  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    println("Received Data!")
    var error : NSError?
    // Master controller getting info from slave controller
//    if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSMutableDictionary {
//      println("Found Dictionary")
//      jsonDict["peerID"] = peerID.displayName
//      delegate.handleEvent(jsonDict)
//    }
    let decoder = NSKeyedUnarchiver(forReadingWithData: data)
    let unarchivedObject: AnyObject? = decoder.decodeObject()
    decoder.finishDecoding()
    println(unarchivedObject!.description)
    
    // Slave controller getting info from master controller
    if let gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameSession {
      println("Recognized data as GameSession.")
      delegate.handleEvent(gameData)
    }
    else if let dataReceivedFromSlave = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary{
      println("Recognized data as NSDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      println(self.delegate)
      self.delegate.handleEvent(newDictionary)
      self.mainBrainDelegate?.handleEvent(newDictionary)
      
    } else if let dataReceivedFromSlave = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableDictionary{
      println("Recognized data as NSMutableDictionary.")
      let newDictionary : NSMutableDictionary = NSMutableDictionary()
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("action")!, forKey: "action")
      newDictionary.setObject(dataReceivedFromSlave.objectForKey("value")!, forKey: "value")
      newDictionary.setObject(peerID.displayName, forKey: "peerID")
      self.delegate.handleEvent(newDictionary)
      self.mainBrainDelegate?.handleEvent(newDictionary)
    }
    else {
      println("Unknown Data Received!")
    }
    
//        var newData: NSMutableData? = userData["userInfo"] as? NSMutableData
//        let passedUser = UserInfo.unwrapUserInfo(newData!)
//        var dictionaryToPass = ["value" : passedUser, "peerID": peerID.displayName, "action": "user"] as NSMutableDictionary
//        self.delegate.handleEvent(dictionaryToPass)
    
    
    
  }
  // TODO: Send User Info
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    if state == MCSessionState.Connected {
      println("\(peerID.displayName) Connected")
      println("Peer Connected")
        //self.userInfo = UserInfo(userName: peerID.description)
        if let delegateCheck = self.delegate as? GameController {
            println("I am not lead controller")
            
        }
      self.delegate.updatePeerCount(session.connectedPeers.count)
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
    //dewrap resource into
  }
  
  // MARK: - MCNearbyServiceAdvertiserDelegate Methods
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
    
    println("Got an invitation and auto-accepting.")
    invitationHandler(true, self.session)
  }
  
  // MARK: - MCNearbyServiceBrowserDelegate Methods
  
  func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
    println("Found peer with id \(peerID.displayName)")
    
    browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
    
  }
  
  func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
    println("Lost peer!")
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
  
  func askForPlayers() {
    
  }
  
  func sendEventToPeers(game: GameSession) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(game)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    if error != nil {
      println(error!.description)
    }
    delegate.handleEvent(game)
  }
  
  func sendInfoToMainBrain(dictionary: NSMutableDictionary) {
    
    var error : NSError?
    let data = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    dictionary.setObject(self.peerID.displayName, forKey: "peerID")
    self.mainBrainDelegate?.handleEvent(dictionary)
  }
    
    func sendUserInfoToLeadController(userInfo: UserInfo){
        userInfo.userPeerID = self.peerID.displayName
        let dictionaryData = ["action" : "user", "value" : userInfo]
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionaryData)
        var error : NSError?
        session.sendData(dataToSend, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        println("sending user info")
    }

}



