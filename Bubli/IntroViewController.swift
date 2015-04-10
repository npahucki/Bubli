//
//  IntroViewController.swift
//  Bubli
//
//  Created by Nathan  Pahucki on 4/2/15.
//  Copyright (c) 2015 Nathan Pahucki. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var explainerLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var moreAppsView: UIView!
    @IBOutlet weak var titleToImageContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var containerMinHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerMaxHeightConstraint: NSLayoutConstraint!
    
    var didInitialAnimation : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        explainerLabel.alpha = 0.0
        startButton.alpha = 0.0
        moreAppsView.alpha = 0.0
        
        // 300, max needed to show 3 additional items.
        // 172 a little less than two items. 
        // 480 is the 4s screen size.
        containerMinHeightConstraint.constant =  300 + (UIScreen.mainScreen().bounds.size.height - 480)/2
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "initiateViewChangeAnimation", userInfo: nil, repeats: false)
        
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
    
    
}
