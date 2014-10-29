//
//  UIClassExtensions.swift
//  Hacker Mission
//
//  Created by Jacob Hawken on 10/28/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    func animateGif(fileName: String, startAnimating: Bool) -> Void
    {
        var animatedGif : UIImage?
        if let gif = UIImage(named: fileName) as UIImage!
        {
            animatedGif = gif
            
            if animatedGif!.images!.count > 1
            {
                self.animationImages = animatedGif!.images
                self.animationDuration = animatedGif!.duration
                if let previewImage = animatedGif!.images?.last as? UIImage
                {
                    self.image = previewImage
                    if startAnimating
                    {
                        self.startAnimating()
                    }
                }
            }
            else
            {
                println("This is not an animated image!")
            }
        }
    }

//extension UILabel  //TODO: FINISH THIS
//{
//    func typingAnimation() -> Void
//    {
//        var textToAnimate = self.text as String?
//        
//    }
//}

}