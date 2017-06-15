//
//  SimpleTest1ViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class SimpleTest1ViewController: BaseCsoundViewController, CsoundObjListener {
    
    @IBOutlet var uiSlider: UISlider!
    @IBOutlet var uiSwitch: UISwitch!
    @IBOutlet var uiLabel: UILabel!

    override func viewDidLoad() {
        title = "01. Simple Test 1"
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        print("Status: \(sender.isOn)")
        
        if sender.isOn {
            let csdFile = Bundle.main.path(forResource: "test", ofType: "csd")
            
            csound = CsoundObj()
            csound.add(self)    // Add self as a 'listener', a kind of delegate, to be notified when Csound starts and/or stops
            let csoundUI = CsoundUI(csoundObj: csound)
            csoundUI?.labelPrecision = 2    // Set label value display precision before adding UILabel binding
            csoundUI?.add(uiLabel, forChannelName: "slider")
            csoundUI?.add(uiSlider, forChannelName: "slider")
            
            csound.play(csdFile)
        } else {
            csound.stop()
        }
    }
    
    // Present info popover
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 200, height: 200)
        infoText = "Flip the switch to begin rendering Csound. Use the slider to control pitch."
        displayInfo(sender) // Call inherited method to display info popover after setting specifics
    }
    
    // CsoundObjListener method: if Csound finishes running, it will call this method
    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in    // Use the main thread for UI operation
            self.uiSwitch.isOn = false  // Turn the switch off
            self.uiLabel.text = ""
        }
    }
}
