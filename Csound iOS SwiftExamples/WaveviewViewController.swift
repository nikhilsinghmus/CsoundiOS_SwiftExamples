//
//  WaveviewViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class WaveviewViewController: BaseCsoundViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var waveview: Waveview!
    
    var fTableIndex = 0
    let fTables = ["Sine", "Exponential Curves", "Data Points", "Normalizing Function", "Triangle"]

    override func viewDidLoad() {
        title = "09. F-table Viewer"
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tempFile = Bundle.main.path(forResource: "Waveviewtest", ofType: "csd")
        
        csound.stop()
        csound = CsoundObj()
        csound.addBinding(waveview)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(incrementFTable(_:)))
        waveview.addGestureRecognizer(tap)
        
        csound.play(tempFile)
    }
    
    @IBAction func incrementFTable(_ tap: UITapGestureRecognizer) {
        fTableIndex += 1
        fTableIndex %= fTables.count
        titleLabel.text = fTables[fTableIndex]
        waveview.displayFTable(fTableIndex+1)
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 120)
        infoText = "Demonstrates using a Csound binding to draw F-table content to a view. Tap the screen to cycle through available F-tables."
        displayInfo(sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}