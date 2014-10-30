//
//  Jake Class Extensions.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/30/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    func typingAnimation(durationPerCharacter : Float) -> Void
    {
        let textToAnimate = self.text as String?
        var characterArray : [String]!
        characterArray = textToAnimate?.pathComponents
        if characterArray == nil
        {
            println("Empty string. Nothing to animate.")
        }
        else
        {
            var animationQueue = NSOperationQueue()
            animationQueue.maxConcurrentOperationCount = 1
            var sleepLength = UInt32(durationPerCharacter)
            var outputString : String = "_"
            var isFirstCycle = true
            
            for character in characterArray!
            {
                if outputString == "_"
                {
                    if isFirstCycle
                    {
                        isFirstCycle = false
                    }
                    else
                    {
                        outputString = character
                    }
                }
                else
                {
                    outputString = outputString + character
                }
                animationQueue.addOperationWithBlock
                { () -> Void in
                    sleep(sleepLength)
                    NSOperationQueue.mainQueue().addOperationWithBlock(
                    { () -> Void in
                        self.text = outputString + "_"
                    })
                }
            }
            self.cursorBlink()
        }
    }
    
    func cursorBlink ()  //made to be used after typingAnimation
    {
        let animationQueue = NSOperationQueue()
        animationQueue.maxConcurrentOperationCount = 1
        if (self.text?.hasSuffix("_") == false)
        {
            self.text = self.text! + "_"
        }
        let withCursor = self.text?
        var withoutCursor = self.text?.stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        animationQueue.addOperationWithBlock
        { () -> Void in
            for var i=0; i<60; i++
            {
                sleep(1)
                NSOperationQueue.mainQueue().addOperationWithBlock(
                { () -> Void in
                    self.text = withoutCursor
                })
                sleep(1)
                NSOperationQueue.mainQueue().addOperationWithBlock(
                { () -> Void in
                    self.text = withCursor
                })
            }
        }
    }
}