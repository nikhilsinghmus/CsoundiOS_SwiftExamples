//
//  TrappedGeneratorViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit
import AVFoundation

class TrappedGeneratorViewController: BaseCsoundViewController {
    
    var hasRendered = false
    var localFileURL: URL?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        title = "06. Render: Trapped in Convert"
        super.viewDidLoad()
    }
    
    // Render Trapped in Convert, using trapped.csd, to a file
    @IBAction func generateTrappedToDocumentsFolder(_ sender: UIButton) {
        let csdPath = Bundle.main.path(forResource: "trapped", ofType: "csd")
        let docsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        localFileURL = docsDirURL.appendingPathComponent("trapped.wav")
        
        csound.stop()
        csound = CsoundObj()
        csound.add(self)
        // Render offline (there are other methods to record in realtime)
        if localFileURL != nil {
            csound.record(csdPath, toFile: localFileURL!.path)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(_ sender: UIButton) {
        if hasRendered {
            if localFileURL != nil {
                do {
                    player = try AVAudioPlayer(contentsOf: localFileURL!)
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
            player?.prepareToPlay()
            player?.play()
        } else {
            let alert = UIAlertController(title: "Not Rendered", message: "Please render the file before playing it.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        if player != nil {
            if player!.isPlaying {
                player!.stop()
            }
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 140)
        infoText = "This example demonstrates creating a virtual Csound console, and implementing a method to update this virtual console with information accessed from CsoundObj."
        displayInfo(sender)
    }
}

extension TrappedGeneratorViewController: CsoundObjListener {
    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        // Display a UIAlertController to the user notifying them of render completion
        let alert = UIAlertController(title: "Render Complete", message: "File generated as trapped.wav in application Documents Folder.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
        hasRendered = true
    }
}
