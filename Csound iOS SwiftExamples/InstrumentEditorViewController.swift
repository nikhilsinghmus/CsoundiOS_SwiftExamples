//
//  InstrumentEditorViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class InstrumentEditorViewController: BaseCsoundViewController {
    
    @IBOutlet var orchestraTextView: UITextView!

    override func viewDidLoad() {
        title = "08, Instrument Tweaker"
        super.viewDidLoad()
        
        let csdFile = Bundle.main.path(forResource: "instrumentEditor", ofType: "csd")
        csound.stop()
        csound.play(csdFile)
    }
    
    // Trigger an instance of the instrument
    @IBAction func trigger(_ sender: UIButton) {
        csound.updateOrchestra(orchestraTextView.text)
        csound.sendScore("i1 0 1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 120)
        infoText = "This example allows the user to modify the contents of the .csd on-the-fly using the updateOrchestra method from CsoundObj."
        displayInfo(sender)
    }

}
