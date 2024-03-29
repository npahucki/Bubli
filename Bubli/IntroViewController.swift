//
//  IntroViewController.swift
//  Bubli
//
//  Created by Nathan  Pahucki on 4/2/15.
//  Copyright (c) 2015 Nathan Pahucki. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, IQApplicationListDelegate {

    @IBOutlet weak var explainerLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var moreAppsView: UIView!
    @IBOutlet weak var titleToImageContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var containerMinHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerMaxHeightConstraint: NSLayoutConstraint!
    
    private var didInitialAnimation : Bool = false
    private var _parentalGateUnlocked : Bool = false
    private var _gateController =  HTKParentalGateViewController()
    private var _pendingApplicaitonToOpen : IQApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        explainerLabel.alpha = 0.0
        startButton.alpha = 0.0
        moreAppsView.alpha = 0.0
        
        for controller in self.childViewControllers {
            if let listController = controller as? IQApplicationListController {
                listController.delegate = self
                break
            }
        }

        containerMinHeightConstraint.constant =  min(containerMaxHeightConstraint.constant, 300 + (UIScreen.mainScreen().bounds.size.height - 480)/2)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "initiateViewChangeAnimation", userInfo: nil, repeats: false)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleValidationStateChangedNotification:", name: "HTKParentalGateValidationStateChangedNotification", object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    @objc func initiateViewChangeAnimation() {
        
        if UIScreen.mainScreen().bounds.size.height < 768 {
            titleToImageContainerConstraint.active = false
            self.view.setNeedsLayout()
        }

        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.backImage.alpha = 0.05
            self.copyrightLabel.alpha = 0.0
            self.explainerLabel.alpha = 1.0
            self.moreAppsView.alpha = 1.0
            self.startButton.alpha = 1.0
            self.view.layoutIfNeeded()
            }) { (Bool complete) -> Void in
                self.didInitialAnimation = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didInitialAnimation {
            let activte = UIScreen.mainScreen().bounds.size.height >= 768
            if titleToImageContainerConstraint.active != activte {
                    titleToImageContainerConstraint.active = activte
                self.view.setNeedsLayout()
                
            }
        }
    }
    
    func shouldOpenApp(app: IQApplication!) -> Bool {
        Heap.track("clickedOtherApp", withProperties: ["bundleId" : app.appBundleId])
        if !_parentalGateUnlocked {
            _pendingApplicaitonToOpen = app
            _gateController.showInParentViewController(self, fullScreen: false)
            return false;
        }
        
        return true;
    }
    
    func handleValidationStateChangedNotification(notification : NSNotification ) {
        assert(NSThread.isMainThread())
        let state = notification.userInfo!["HTKParentalGateValidationStateChangedKey"]! as! NSNumber
        if state.integerValue  == Int(HTKParentalGateValidationState.IsValidated.rawValue) {
            _parentalGateUnlocked = true
            if let app = _pendingApplicaitonToOpen {
                _pendingApplicaitonToOpen = nil
                app.openInAppStore()
            }
        }
    }
}
