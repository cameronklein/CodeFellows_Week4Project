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

  func typeToNewString(finalText: String, withInterval sleepLength : Double, var startingText : String = "") {
    if startingText == "" {
      self.text = startingText
      for character in finalText{
        startingText = String(character)
        break
      }
    }
    if countElements(startingText) < countElements(finalText) {
      let rangeOfStartText = finalText.rangeOfString(startingText, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
      let lastIndex = rangeOfStartText?.endIndex
      let nextIndex = lastIndex?.successor()
      let nextText = finalText.substringToIndex(nextIndex!)
    
      let view = UIView()
      self.superview?.addSubview(view)
    
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        
        UIView.animateWithDuration(sleepLength,
          delay: 0.00,
          options: UIViewAnimationOptions.AllowUserInteraction,
          animations: { () -> Void in
            if view.alpha == 0{
              view.alpha = 1
            } else {
              view.alpha = 0
            }
            self.text = "\(nextText)_"
          },
          completion: { (success) -> Void in
            if success == true{
              self.typeToNewString(finalText, withInterval: sleepLength, startingText: nextText)
            }
        })
      }
    } else {
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