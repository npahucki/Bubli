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
    
    private lazy var touchImgViewsDict = [Int:UIImageView]()
    private lazy var touchImgArray = [UIImageView]()
    
    private var touchOne : UITouch?
    private var touchTwo : UITouch?
    private var touchThree : UITouch?
    
    private var redVal : CGFloat = 0.0
    private var redPulse : CGFloat = 0.0
    private var blueVal : CGFloat = 0.0
    private var bluePulse : CGFloat = 0.0
    private var greenVal : CGFloat = 0.0
    private var greenPulse :CGFloat = 0.0
    
    private var timer : NSTimer!
    
    private var fm1 = FMOscillator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...9 { // 10 touches
            touchImgArray.append(UIImageView(image: UIImage(named: "touchSmiley")))
        }
        
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

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        for touch in touches as! Set<UITouch> {
            if let touchImgView = touchImgViewsDict[touch.hash] {
                    touchImgView.center = touch.locationInView(view)
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        instructionsLabel.hidden = true
        super.touchesBegan(touches, withEvent: event)
        for touch in touches as! Set<UITouch> {

            let touchImgView = touchImgArray.removeLast()
            touchImgView.center = touch.locationInView(view)
            view.addSubview(touchImgView)
            touchImgView.alpha = 0.0
            touchImgView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            touchImgViewsDict[touch.hash] = touchImgView
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                touchImgView.alpha = 1.0
                touchImgView.transform = CGAffineTransformMakeScale(1, 1)
            })

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
        handleTouchedEndedOrCanceled(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        handleTouchedEndedOrCanceled(touches, withEvent: event)
    }

    func handleTouchedEndedOrCanceled(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches as! Set<UITouch> {
            
            if let touchImgView = touchImgViewsDict[touch.hash] {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    touchImgView.alpha = 0.0
                    touchImgView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                    }, completion: { (complete : Bool) -> Void in
                    touchImgView.removeFromSuperview()
                    touchImgView.alpha = 1.0
                    self.touchImgArray.append(touchImgView)
                    self.touchImgViewsDict.removeValueForKey(touch.hash)
                })
            }
            
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

