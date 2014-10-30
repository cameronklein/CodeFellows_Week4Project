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
        }
    }
}