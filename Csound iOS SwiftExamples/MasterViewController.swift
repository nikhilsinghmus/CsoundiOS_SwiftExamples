//
//  MasterViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var allVCClasses: [BaseCsoundViewController.Type] = [SimpleTest1ViewController.self,
                                                    SimpleTest2ViewController.self,
                                                    ButtonTestViewController.self,
                                                    CsoundHaiku4ViewController.self,
                                                    TrappedGeneratorViewController.self,
                                                    ConsoleOutputViewController.self,
                                                    InstrumentEditorViewController.self,
                                                    WaveviewViewController.self,
                                                    AudioFilesTestViewController.self,
                                                    AudioInTestViewController.self,
                                                    HarmonizerTestViewController.self,
                                                    RecordTestViewController.self,
                                                    MidiTestViewController.self,
                                                    HardwareTestViewController.self,
                                                    MultiTouchXYViewController.self,
                                                    PitchShifterViewController.self]
    
    let testNames = ["01. Simple Test 1",
                    "02. Simple Test 2",
                    "03. Button Test",
                    "04. Play: Haiku IV",
                    "05. Render: Trapped in Convert",
                    "06. Render: Console Output",
                    "07. Instrument Tweaker",
                    "08. F-table Viewer",
                    "09. Soundfile: Pitch Shifter",
                    "10. Mic: Stereo Delay",
                    "11. Mic: Harmonizer",
                    "12. Mic: Recording",
                    "13. Hardware: MIDI Controller",
                    "14. Hardware: Motion Control",
                    "15. XY Pad: MultiTouch ",
                    "16. XY Pad: Mic PitchShift+Mix"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Csound for iOS"
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            tableView.selectRow(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .middle)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = testNames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: Any?
        
        if indexPath.row == 12, UIDevice.current.userInterfaceIdiom == .pad {
            controller = allVCClasses[indexPath.row].init(nibName: String(describing: allVCClasses[indexPath.row]) + "_iPad", bundle: nil)
        } else if indexPath.row == 0 {
            controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SimpleTest1ViewController")
        } else {
            controller = allVCClasses[indexPath.row].init(nibName: String(describing: allVCClasses[indexPath.row]), bundle: nil)
        }
        
        if controller != nil {
            if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(controller as! BaseCsoundViewController, animated: true)
            } else {
                let navCon = UINavigationController(rootViewController: controller as! BaseCsoundViewController)
                splitViewController?.viewControllers = [navigationController!, navCon]
                splitViewController?.delegate = controller as! BaseCsoundViewController
                
                if UIDevice.current.orientation == .portrait {
                    UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                        self.splitViewController?.preferredDisplayMode = .primaryHidden
                    })
                }
            }
        }
    }


}

