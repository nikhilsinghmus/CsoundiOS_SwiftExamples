//
//  SimpleTest1ViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
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
            csound.add(self)
            let csoundUI = CsoundUI(csoundObj: csound)
            csoundUI?.labelPrecision = 2
            csoundUI?.add(uiLabel, forChannelName: "slider")
            csoundUI?.add(uiSlider, forChannelName: "slider")
            
            csound.play(csdFile)
        } else {
            csound.stop()
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 200, height: 200)
        infoText = "Flip the switch to begin rendering Csound. Use the slider to control pitch."
        displayInfo(sender)
    }
    
    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in
            self.uiSwitch.isOn = false
            self.uiLabel.text = ""
        }
    }
}
