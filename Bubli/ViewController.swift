//
//  ViewController.swift
//  Bubli
//
//  Created by Nathan  Pahucki on 12/18/14.
//  Copyright (c) 2014 Nathan Pahucki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var touchOne : UITouch?
    var touchTwo : UITouch?
    var touchThree : UITouch?
    
    var redVal : CGFloat = 0.0
    var redPulse : CGFloat = 0.0
    var blueVal : CGFloat = 0.0
    var bluePulse : CGFloat = 0.0
    var greenVal : CGFloat = 0.0
    var greenPulse :CGFloat = 0.0
    
    var timer : NSTimer!
    
    var fm1 = FMOscillator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.multipleTouchEnabled = true
        AKOrchestra.addInstrument(fm1)
        AKOrchestra.start()
        fm1.play()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0 / 30.0, target: self, selector: "updateBackgroundColor", userInfo: nil, repeats: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "prepareForBackground", name:UIApplicationWillResignActiveNotification , object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        fm1.start()
    }
    
    private func reset() {
        redVal = 0.0
        redPulse = 0.0
        blueVal  = 0.0
        bluePulse = 0.0
        greenVal = 0.0
        greenPulse = 0.0
        fm1.reset()
    }
    

    @objc func prepareForBackground() {
        fm1.reset()
        fm1.stop()
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    @objc
    func updateBackgroundColor() {

        if let redTouch = touchOne {
            redPulse = setPropertyByXTouch(fm1.frequency, touch: redTouch)
            redVal = setPropertyByYTouch(fm1.amplitude, touch: redTouch)
        }
        if let greenTouch = touchTwo {
            greenPulse = setPropertyByXTouch(fm1.carrierMultiplier, touch: greenTouch)
            greenVal  = setPropertyByYTouch(fm1.modulatingMultiplier, touch: greenTouch)
        }
        if let blueTouch = touchThree {
            bluePulse = setPropertyByXTouch(fm1.modulationIndex, touch: blueTouch)
            blueVal = blueTouch.locationInView(view).y / view.bounds.height
        }

        let maxPulse = CGFloat(5.0)
        let maxFade = CGFloat(0.15)
        let red = redVal - (redVal * maxFade * CGFloat(abs(cos(CGFloat(CACurrentMediaTime()) * redPulse * maxPulse))))
        let green = greenVal - (greenVal * maxFade * CGFloat(abs(cos(CGFloat(CACurrentMediaTime()) * greenPulse * maxPulse))))
        let blue = blueVal - (blueVal * maxFade * CGFloat(abs(cos(CGFloat(CACurrentMediaTime()) * bluePulse * maxPulse))))
        let color = UIColor(red: red  , green: green, blue: blue, alpha: 1.0)
        view.backgroundColor = color
    }
    
    private func setPropertyByXTouch(prop : AKInstrumentProperty, touch : UITouch) -> CGFloat {
        let x = touch.locationInView(view).x
        let percent = x / view.bounds.width
        prop.value = Float(percent) * (prop.maximum - prop.minimum) + prop.minimum
        return percent
    }

    private func setPropertyByYTouch(prop : AKInstrumentProperty, touch : UITouch)-> CGFloat {
        let percent = touch.locationInView(view).y / view.bounds.height
        prop.value = Float(percent) * (prop.maximum - prop.minimum) + prop.minimum
        return percent
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        instructionsLabel.hidden = true
        
        super.touchesBegan(touches, withEvent: event)
        
        for touch in touches as! Set<UITouch> {
            if touchOne == nil {
                touchOne = touch
            } else if (touchTwo == nil) {
                touchTwo = touch
            } else if (touchThree == nil) {
                touchThree = touch
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent!) {
        super.touchesCancelled(touches,withEvent: event)
        for touch in touches as! Set<UITouch> {
            if touch == touchOne {
                touchOne = nil
            }
            if touch == touchTwo {
                touchTwo = nil
            }
            if touch == touchThree {
                touchThree = nil
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        for touch in touches as! Set<UITouch> {
            if touch == touchOne {
                touchOne = nil
            }
            if touch == touchTwo {
                touchTwo = nil
            }
            if touch == touchThree {
                touchThree = nil
            }
        }
    }
}

