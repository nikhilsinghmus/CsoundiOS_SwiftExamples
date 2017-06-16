//
//  MultiTouchXYViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class MultiTouchXYViewController: BaseCsoundViewController {
    
    private var touchIds = [Int](repeatElement(0, count: 10))
    private var touchArray = [UITouch?](repeatElement(nil, count: 10))
    private var touchesCount = 0
    fileprivate var touchX = [Float](repeatElement(0, count: 10))
    fileprivate var touchY = [Float](repeatElement(0, count: 10))
    fileprivate var touchXPtr = [UnsafeMutablePointer<Float>?](repeatElement(nil, count: 10))
    fileprivate var touchYPtr = [UnsafeMutablePointer<Float>?](repeatElement(nil, count: 10))
    
    @IBOutlet var touchesLabel: UILabel!

    override func viewDidLoad() {
        title = "15. MultiTouch XY Pad"
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tempFile = Bundle.main.path(forResource: "multiTouchXY", ofType: "csd")
        
        csound.stop()
        csound = CsoundObj()
        
        csound.addBinding(self)
        csound.play(tempFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cleanup() {
        for i in 0 ..< 10 {
            touchXPtr[i] = nil
            touchYPtr[i] = nil
        }
    }
    
    func getTouchIdAssignment() -> Int {
        for i in 0 ..< 10 {
            if touchIds[i] == 0 {
                return i
            }
        }
        return -1
    }
    
    func getTouchId(_ touch: UITouch) -> Int {
        for i in 0 ..< 10 {
            if touchArray[i] == touch {
                return i
            }
        }
        return -1
    }
    
    // MARK: Touch Handling Code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchId = getTouchIdAssignment()
            if touchId != -1 {
                touchArray[touchId] = touch
                touchIds[touchId] = 1
                
                let pt = touch.location(in: view)
                touchX[touchId] = Float(pt.x / view.frame.size.width)
                touchY[touchId] = Float(1 - (pt.y / view.frame.size.height))    // Invert Y axis
                
                touchXPtr[touchId]?.pointee = touchX[touchId]
                touchYPtr[touchId]?.pointee = touchY[touchId]
                
                csound.sendScore("i1.\(touchId) 0 -1 \(touchId)")
                touchesCount += touches.count
                touchesLabel.text = "Touches \(touchesCount)"
                
                if touchesCount > (event?.allTouches?.count)! {
                    touchesCount = (event?.allTouches?.count)!
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchId = getTouchId(touch)
            if touchId != -1 {
                let pt = touch.location(in: view)
                touchX[touchId] = Float(pt.x / view.frame.size.width)
                touchY[touchId] = Float(1 - (pt.y / view.frame.size.height))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchId = getTouchId(touch)
            if touchId != -1 {
                touchIds[touchId] = 0
                touchArray[touchId] = nil
                csound.sendScore("i-1.\(touchId) 0 0 \(touchId)")
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchId = getTouchId(touch)
            if touchId != -1 {
                touchIds[touchId] = 0
                touchArray[touchId] = nil
                csound.sendScore("i-1.\(touchId) 0 0 \(touchId)")
            }
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 120)
        infoText = "Multitouch XY Pad demonstrates a multitouch performance surface. Each touch is dynamically mapped to a unique instance of a Csound instrument."
        displayInfo(sender)
    }
}

extension MultiTouchXYViewController: CsoundBinding {
    func setup(_ csoundObj: CsoundObj!) {
        for i in 0 ..< 10 {
            touchXPtr[i] = csoundObj.getInputChannelPtr("touch.\(i).x", channelType: CSOUND_CONTROL_CHANNEL)
            touchYPtr[i] = csoundObj.getOutputChannelPtr("touch.\(i).y", channelType: CSOUND_CONTROL_CHANNEL)
        }
    }
    
    func updateValuesToCsound() {
        for i in 0 ..< 10 {
            touchXPtr[i]?.pointee = touchX[i]
            touchYPtr[i]?.pointee = touchY[i]
        }
    }
}
