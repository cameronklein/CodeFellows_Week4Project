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

  @IBOutlet weak var pageControl: UIPageControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    beginningVC = OnboardPageViewController(nibName: "OnboardPageViewController", bundle: NSBundle.mainBundle())
      beginningVC.p1 = "Hacker Missions is a party game for a group of five to ten players."
      beginningVC.p2 = "Play with your friends in the same room and look them in the eyes while they lie to you."
      beginningVC.p3 = "You will assume the role of a courageous hacker, living in a country with an evil, corrupt, totalitarian government."
      beginningVC.p4 = "Your goal : Take down the government by completing three missions that will embarrass the regime so much they will crumble."
      beginningVC.p5 = "The hitch : Some of your \"friends\" are spies and will do anything to stop you from succeeding."
      beginningVC.p6 = "Aren't friends great? You should have more of them."
    
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
    let VC2 = OnboardPageViewController(nibName: "OnboardPageViewController", bundle: NSBundle.mainBundle())
    VC2.p1 = "A leader will be assigned for each mission. The leader will nominate a team to carry out the mission."
    VC2.p2 = "The nominations will be put to a vote. Every layer gets to vote on whether the team is approved. If the team is approved, the mission proceeds. If not, the leadership rotates to the next player and a new team will need to be proposed."
    VC2.p3 = "If five nominated teams in a  row fail to be approved, the mission will fail. Who dares, wins, after all."
    VC2.p4 = "The brave nominees will then carry out the mission. Planned to a tee, the mission will succeed unless sabotaged."
    VC2.p5 = "If a government agent is in the team, however, they can choose to sabotage the mission."
    VC2.p6 = "Or not. Spies are sneaky. You can't trust them. Some of your friends are spies. You can't trust them, either."
    
    let VC3 = OnboardPageViewController(nibName: "OnboardPageViewController", bundle: NSBundle.mainBundle())
    VC3.p1 = "If three missions succeed, the hackers win and the government is overthrown. There is dancing in the streets and statues topple."
    VC3.p2 = "But if three missions fail, the hidden agents win and the totalitarian regime lives on. And you, brave hacker, will be..."
    VC3.p3 = "\"Re-educated.\""
    VC3.p4 = "Choose your teams wisely."
    VC3.p5 = "Sniff out the spies."
    VC3.p6 = "Trust no one."
    
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
