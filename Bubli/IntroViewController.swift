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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        explainerLabel.alpha = 0.0
        startButton.alpha = 0.0
        
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.backImage.alpha = 0.05
            self.copyrightLabel.alpha = 0.0
            self.explainerLabel.alpha = 1.0
            self.startButton.alpha = 1.0
        }) { (Bool complete) -> Void in
            //
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}
