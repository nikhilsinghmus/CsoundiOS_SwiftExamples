//
//  PitchShifterViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class PitchShifterViewController: BaseCsoundViewController, CsoundObjListener {

    @IBOutlet var mSwitch: UISwitch!
    @IBOutlet var mXYControl: ControlXYGrid!
    
    override func viewDidLoad() {
        title = "16. Mic: XY PitchShift+Mix"
        super.viewDidLoad()
        
        mXYControl.setXValue(1.0)
        mXYControl.setYValue(0.5)
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        if sender.isOn {
            let tempFile = Bundle.main.path(forResource: "pitchshifter", ofType: "csd")
            
            csound.stop()
            csound = CsoundObj()
            csound.useAudioInput = true
            csound.add(self)
            csound.addBinding(mXYControl)
            
            csound.play(tempFile)
        } else {
            csound.stop()
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 150)
        infoText = "This example uses Csound's 'pvs' real-time spectral-processing opcodes to perform pitch-shifting on a live microphone input signal, controlled with a custom XY control pad."
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
