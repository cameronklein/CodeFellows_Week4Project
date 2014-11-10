//
//  RootOnboardViewController.swift
//  Hacker Mission
//
//  Created by Cameron Klein on 11/2/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class RootOnboardViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  var pageViewController : UIPageViewController!
  var beginningVC : OnboardPageViewController!
  var controllers = [UIViewController]()
  var onboardDict : NSDictionary!

  @IBOutlet weak var pageControl: UIPageControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    beginningVC = OnboardPageViewController(nibName: "OnboardPageViewController", bundle: NSBundle.mainBundle())
    beginningVC.p1 = flavorTextOne["p1"]
    beginningVC.p2 = flavorTextOne["p2"]
    beginningVC.p3 = flavorTextOne["p3"]
    beginningVC.p4 = flavorTextOne["p4"]
    beginningVC.p5 = flavorTextOne["p5"]
    beginningVC.p6 = flavorTextOne["p6"]
    
    self.setupArray()
    let VCArray = [beginningVC]
    pageViewController.setViewControllers(VCArray, direction: .Forward, animated: true, completion: nil)
    pageViewController.delegate = self
    pageViewController.dataSource = self
    
    self.addChildViewController(self.pageViewController!)
    self.view.addSubview(self.pageViewController!.view)
    self.pageViewController.view.frame = self.view.frame
    
    self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
  }
  
  func setupArray() {
    let flavorTextTwo = onboardDict["PageTwo"] as [String : String]
    let VC2 = OnboardPageViewController(nibName: "OnboardPageViewController", bundle: NSBundle.mainBundle())
    VC2.p1 = flavorTextTwo["p1"]
    VC2.p2 = flavorTextTwo["p2"]
    VC2.p3 = flavorTextTwo["p3"]
    VC2.p4 = flavorTextTwo["p4"]
    VC2.p5 = flavorTextTwo["p5"]
    VC2.p6 = flavorTextTwo["p6"]
    
    let VC3 = OnboardPageViewController(nibName: "OnboardPageViewController", bundle: NSBundle.mainBundle())
    let flavorTextThree = onboardDict["PageThree"] as [String : String]
    VC3.p1 = flavorTextThree["p1"]
    VC3.p2 = flavorTextThree["p2"]
    VC3.p3 = flavorTextThree["p3"]
    VC3.p4 = flavorTextThree["p4"]
    VC3.p5 = flavorTextThree["p5"]
    VC3.p6 = flavorTextThree["p6"]
    
    controllers.append(beginningVC)
    controllers.append(VC2)
    controllers.append(VC3)
    
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let charCreate = storyboard.instantiateViewControllerWithIdentifier("CHARCREATE_VC") as CharacterCreationViewController
    charCreate.view.backgroundColor = UIColor.clearColor()
    charCreate.blurView.removeFromSuperview()
    controllers.append(charCreate)
    pageControl.numberOfPages = controllers.count
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
      var vcFound = false
      for vc in controllers {
        if vcFound == true {
          return vc
        }
        if vc == viewController {
          vcFound = true
        }
      }
    
    return nil
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
      var i = 0
      for vc in controllers {
        if vc == viewController {
          if i > 0 {
            return controllers[i-1]
          }
        }
        i = i + 1
      }
    
    return nil
  }

  func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
    println(pendingViewControllers)
    let middleVC = pendingViewControllers[0] as UIViewController
    var i = 0
    for vc in controllers {
      if vc == middleVC {
        pageControl.currentPage = i
      }
      i += 1
    }
  }
  
  
}
