//
//  ViewController.swift
//  MultiPeer Experiment
//
//  Created by Cameron Klein on 10/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPeer: UIViewController, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate {
  
  var peerID      : MCPeerID!
  var session     : MCSession!
  var advertiser  : MCNearbyServiceAdvertiser!
  var browser     : MCNearbyServiceBrowser!
  var assistant   : MCAdvertiserAssistant!
  let XXServiceType = "xx-servicetype"
  
  override func viewDidLoad() {
    println("Multipeer View Controller Loaded")
    super.viewDidLoad()
    
    peerID  = MCPeerID(displayName: UIDevice.currentDevice().name)
    session = MCSession(peer: peerID)
    
    self.session.delegate = self
    
    assistant = MCAdvertiserAssistant(serviceType: XXServiceType, discoveryInfo: nil, session: session)
    //assistant.start()
    
  }
  
  func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    println("Got Resource")
  }
  
  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    println("Received Data!")
  }
  
  func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    println("Received Stream!")
  }
  
  func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    println("Started Receiving Resource")
  }
  
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    println("Changed State")
  }
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
    
    println("Got an invitation")
    var didAccept = false
    let alert = UIAlertController(title: "You have been invited by \(peerID)", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
      didAccept = true
    }
    let no = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      alert.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(ok)
    alert.addAction(no)
    self.presentViewController(alert, animated: true, completion: nil)
    
    let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    session.delegate = self
    
    invitationHandler(didAccept, session)
    
  }
  
  @IBAction func didPressButton(sender: AnyObject) {
    println("Started Advertising")
    
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: XXServiceType)
    advertiser.delegate = self
    advertiser.startAdvertisingPeer()
    
  }
  
  @IBAction func didPressBrowsingButton(sender: AnyObject) {
    println("Started Browsing")
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: XXServiceType)
    browser.delegate = self
    let browserVC = MCBrowserViewController(browser: browser, session: session)
    //self.presentViewController(browserVC, animated: true, completion: nil)
    browser.startBrowsingForPeers()
  }
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
    println("Found peer with id \(peerID)")
    browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
  }
  
  func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
    println("Lost peer!")
  }
  
}

//  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//  }
//
//  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//  }


