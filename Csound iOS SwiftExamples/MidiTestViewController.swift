//
//  MidiTestViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class MidiTestViewController: BaseCsoundViewController, CsoundObjListener, CsoundVirtualKeyboardDelegate {
    
    @IBOutlet var mAttackSlider: UISlider!
    @IBOutlet var mDecaySlider: UISlider!
    @IBOutlet var mSustainSlider: UISlider!
    @IBOutlet var mReleaseSlider: UISlider!
    
    @IBOutlet var mCutoffSlider: UISlider!
    @IBOutlet var mResonanceSlider: UISlider!
    
    @IBOutlet var mSwitch: UISwitch!
    let widgetsManager = MidiWidgetsManager()

    override func viewDidLoad() {
        title = "04. Hardware: MIDI Controller"
        
        widgetsManager.add(mAttackSlider, forControllerNumber: 1)
        widgetsManager.add(mDecaySlider, forControllerNumber: 2)
        widgetsManager.add(mSustainSlider, forControllerNumber: 3)
        widgetsManager.add(mReleaseSlider, forControllerNumber: 4)
        widgetsManager.add(mCutoffSlider, forControllerNumber: 5)
        widgetsManager.add(mResonanceSlider, forControllerNumber: 6)
        widgetsManager.openMidiIn()
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        widgetsManager.closeMidiIn()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        if sender.isOn {
            let tempFile = Bundle.main.path(forResource: "midiTest", ofType: "csd")
            
            csound.stop()
            csound = CsoundObj()
            csound.add(self)
            
            let csoundUI = CsoundUI(csoundObj: csound)
            csoundUI?.add(mAttackSlider, forChannelName: "attack")
            csoundUI?.add(mDecaySlider, forChannelName: "decay")
            csoundUI?.add(mSustainSlider, forChannelName: "sustain")
            csoundUI?.add(mReleaseSlider, forChannelName: "release")
            csoundUI?.add(mCutoffSlider, forChannelName: "cutoff")
            csoundUI?.add(mResonanceSlider, forChannelName: "resonance")
            
            csound.midiInEnabled = true
            csound.play(tempFile)
        } else {
            csound.stop()
        }
    }
    
    @IBAction func midiPanic(_ sender: UIButton) {
        csound.sendScore("i \"allNotesOff\" 0 1")
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 110)
        infoText = "This example demonstrate MIDI input from hardware, as well an on-screen (simulated) MIDI keyboard."
        displayInfo(sender)
    }
    
    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in
            self.mSwitch.isOn = false
        }
    }
    
    func keyDown(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        let midikey = 60 + keyNum
        csound.sendScore(String(format: "i1.%003d 0 -1 \(midikey) 0", midikey))
    }
    
    func keyUp(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        let midikey = 60 + keyNum
        csound.sendScore(String(format: "i-1.%003d 0 0", midikey))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
