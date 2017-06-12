//
//  CsoundHaiku4ViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit
import SafariServices

class CsoundHaiku4ViewController: BaseCsoundViewController {

    override func viewDidLoad() {
        title = "05. Play: Haiku IV"
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tempFile = Bundle.main.path(forResource: "IV", ofType: "csd")
        
        csound.stop()
        csound = CsoundObj()
        csound.play(tempFile)
    }
    
    @IBAction func showSite(_ sender: UIButton) {
        let url: URL! = URL(string: "http://iainmccurdy.org/csoundhaiku.html")
        let safariVC = SFSafariViewController(url: url)
        
        present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 180)
        infoText = "Haiku IV is the fourth in a suite of nine generative Csound pieces by Iain McCurdy. Csound begins rendering the work when the view appears and stops when the view unloads and CsoundObj is deallocated."
        displayInfo(sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
