//
//  HarmonizerTest.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class HarmonizerTestViewController: BaseCsoundViewController, CsoundObjListener {
    
    @IBOutlet var mHarmPitchSlider: UISlider!
    @IBOutlet var mGainSlider: UISlider!
    @IBOutlet var mSwitch: UISwitch!

    override func viewDidLoad() {
        title = "12. Mic: Harmonizer"
        super.viewDidLoad()
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        if sender.isOn {
            let tempFile = Bundle.main.path(forResource: "harmonizer", ofType: "csd")
            
            csound.stop()
            csound = CsoundObj()
            csound.useAudioInput = true
            csound.add(self)
            
            let csoundUI = CsoundUI(csoundObj: csound)
            csoundUI?.add(mHarmPitchSlider, forChannelName: "slider")
            csoundUI?.add(mGainSlider, forChannelName: "gain")
            
            csound.play(tempFile)
        } else {
            csound.stop()
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 120)
        infoText = "This examples uses Csound's streaming phase vocoder to create a harmonizer effect. A dry/wet balance control is provided."
        displayInfo(sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in
            self.mSwitch.isOn = false
        }
    }
}
