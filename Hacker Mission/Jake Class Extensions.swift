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
    func typingAnimation() -> Void
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
            var outputString : String?
            
            for character in characterArray!
            {
                if outputString == nil
                {
                    outputString = character
                }
                else
                {
                    outputString = outputString! + character
                }
                self.text = outputString! + "_"
            }
        }
    }
}