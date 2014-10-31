//
//  AppDelegate.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 10/27/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let multipeerController = MultiPeerController.sharedInstance
  var defaultUser: UserInfo?
  var documentsPath : String?

  func checkDefaultsForUser() {

  }

  func saveDefaultPath() {
      if let path = self.makeSavePath() {
      let fileComponent = "ArchivedUser"
      let filePath = path.stringByAppendingPathComponent(fileComponent)

      self.documentsPath = filePath as String!
      println("created the docs path")
      } else {
      println("ERROR: Could not create and store file path for saving user defaults")
    }

  }


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

      self.saveDefaultPath()

    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(self.documentsPath!) {
      println("Success: Saved user data found.")
      var userForLoad = UserInfo.loadTheObject()
      self.defaultUser = userForLoad as UserInfo!
    } else {
      println("No saved user data found.")
      self.defaultUser = nil
    }


    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    multipeerController.stopAdvertising()
    multipeerController.stopBrowsing()
  }

  func makeSavePath() -> String? {
    let fileManager = NSFileManager.defaultManager()
    let arrayOfPotentialDirectories : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String]
    for directory in arrayOfPotentialDirectories {
    }

    if arrayOfPotentialDirectories.count > 0 {
      let arrayOfValidatedDirectories = arrayOfPotentialDirectories as [String]!
      let pathForSave = arrayOfValidatedDirectories.first
      return pathForSave as String!
    } else {
    println("ERROR: Could not generate an array of directories")
    return nil
    }
  }


}

