//
//  AudioInTestViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class AudioInTestViewController: BaseCsoundViewController, CsoundObjListener {
    
    @IBOutlet var mLeftDelayTimeSlider: UISlider!
    @IBOutlet var mLeftFeedbackSlider: UISlider!
    @IBOutlet var mRightDelayTimeSlider: UISlider!
    @IBOutlet var mRightFeedbackSlider: UISlider!
    @IBOutlet var mSwitch: UISwitch!

    override func viewDidLoad() {
        title = "11. Mic: Stereo Delay"
        super.viewDidLoad()
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        print("Status: \(sender.isOn)")
        
        if sender.isOn {
            let tempFile = Bundle.main.path(forResource: "audioInTest", ofType: "csd")
            
            csound.stop()
            csound = CsoundObj()
            csound.useAudioInput = true
            csound.add(self)
            
            let csoundUI: CsoundUI = CsoundUI(csoundObj: csound)
            csoundUI.add(mLeftDelayTimeSlider, forChannelName: "leftDelayTime")
            csoundUI.add(mLeftFeedbackSlider, forChannelName: "leftFeedback")
            csoundUI.add(mRightDelayTimeSlider, forChannelName: "rightDelayTime")
            csoundUI.add(mRightFeedbackSlider, forChannelName: "rightFeedback")
            
            csound.play(tempFile)
        } else {
            csound.stop()
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 120)
        infoText = "This example shows audio processing in real-time with independent delay-time and feedback settings for each channel."
        displayInfo(sender)
    }
    
    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in
            self.mSwitch.isOn = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
