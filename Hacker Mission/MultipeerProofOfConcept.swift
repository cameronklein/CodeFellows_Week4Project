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
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  var peerID      : MCPeerID!
  var session     : MCSession!
  var advertiser  : MCNearbyServiceAdvertiser!
  var browser     : MCNearbyServiceBrowser!
  var assistant   : MCAdvertiserAssistant!
  let XXServiceType = "xx-servicetype"
  var connectedPeers = [MCPeerID]()
  
  override func viewDidLoad() {
    println("Multipeer View Controller Loaded")
    super.viewDidLoad()
    
    peerID  = MCPeerID(displayName: UIDevice.currentDevice().name)
    self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    self.session.delegate = self
    
    assistant = MCAdvertiserAssistant(serviceType: XXServiceType, discoveryInfo: nil, session: session)
    //assistant.start()
    
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: XXServiceType)
    advertiser.delegate = self
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: XXServiceType)
    browser.delegate = self
    
  }
  
  func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    println("Got Resource")
  }
  
  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    println("Received Data!")
    let text = NSString(data: data, encoding: NSUTF8StringEncoding)
    textField.text = text
  }
  
  func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    println("Received Stream!")
  }
  
  func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    println("Started Receiving Resource")
  }
  
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    if state == MCSessionState.Connected {
      println("Peer Connected")
      label.text = session.connectedPeers.count.description
    } else if state == MCSessionState.NotConnected {
      println("Peer Stopped Connecting")
      label.text = session.connectedPeers.count.description
    } else if state == MCSessionState.Connecting {
      println("Peer Connecting")
      label.text = session.connectedPeers.count.description
    }
  }
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
    session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    session.delegate = self
    
    println("Got an invitation")
    var didAccept = false
    let alert = UIAlertController(title: "Invitation Received!", message: "You have been invited by \(peerID)", preferredStyle: UIAlertControllerStyle.ActionSheet)
    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
      invitationHandler(true, self.session)
    }
    let no = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      invitationHandler(false, self.session)
      alert.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(ok)
    alert.addAction(no)
    self.presentViewController(alert, animated: true, completion: nil)
    
    println(didAccept)
    
    
  }
  
  @IBAction func didPressButton(sender: AnyObject) {
    println("Started Advertising")
    advertiser.startAdvertisingPeer()
  }
  
  @IBAction func didPressBrowsingButton(sender: AnyObject) {
    println("Started Browsing")
    
    //let browserVC = MCBrowserViewController(browser: browser, session: session)
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
  
  @IBAction func shootToPeers(sender: AnyObject) {
    let text = textField.text
    let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    var error : NSError?
    session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    
  }
  
}

//  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//  }
//
//  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//  }


