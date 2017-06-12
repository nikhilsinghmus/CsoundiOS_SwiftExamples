//
//  HardwareTestViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit
import CoreMotion

class HardwareTestViewController: BaseCsoundViewController, CsoundObjListener {
    
    @IBOutlet var mSwitch: UISwitch!
    
    @IBOutlet var accX: UILabel!
    @IBOutlet var accY: UILabel!
    @IBOutlet var accZ: UILabel!
    
    @IBOutlet var gyroX: UILabel!
    @IBOutlet var gyroY: UILabel!
    @IBOutlet var gyroZ: UILabel!
    
    @IBOutlet var roll: UILabel!
    @IBOutlet var pitch: UILabel!
    @IBOutlet var yaw: UILabel!
    
    var csoundMotion = CsoundMotion()
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        title = "14, Hardware: Motion Control"
        super.viewDidLoad()
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        if sender.isOn {
            let tempFile = Bundle.main.path(forResource: "hardwareTest", ofType: "csd")
            
            csound.stop()
            csound = CsoundObj()
            csound.add(self)
            
            csoundMotion = CsoundMotion(csoundObj: csound)
            
            if csoundMotion.motionManager != nil {
                motionManager = csoundMotion.motionManager
                
                if motionManager.isAccelerometerAvailable {
                    csoundMotion.enableAccelerometer()
                    motionManager.accelerometerUpdateInterval = 0.1
                    motionManager.startAccelerometerUpdates(to: .main, withHandler: { [unowned self] (data: CMAccelerometerData?, error: Error?) in
                        if data?.acceleration != nil {
                            self.accX.text = String(format: "%.3f", (data?.acceleration.x)!)
                            self.accY.text = String(format: "%.3f", (data?.acceleration.y)!)
                            self.accZ.text = String(format: "%.3f", (data?.acceleration.z)!)
                        }
                    })
                }
                
                if motionManager.isGyroAvailable {
                    csoundMotion.enableGyroscope()
                    motionManager.gyroUpdateInterval = 0.1
                    motionManager.startGyroUpdates(to: .main, withHandler: { [unowned self] (data: CMGyroData?, error: Error?) in
                        if data?.rotationRate != nil {
                            self.gyroX.text = String(format: "%.3f", (data?.rotationRate.x)!)
                            self.gyroY.text = String(format: "%.3f", (data?.rotationRate.y)!)
                            self.gyroZ.text = String(format: "%.3f", (data?.rotationRate.z)!)
                        }
                    })
                }
                
                if motionManager.isDeviceMotionAvailable {
                    csoundMotion.enableAttitude()
                    motionManager.accelerometerUpdateInterval = 0.1
                    motionManager.startDeviceMotionUpdates(to: .main, withHandler: { [unowned self] (data: CMDeviceMotion?, error: Error?) in
                        if data?.attitude != nil {
                            self.roll.text = String(format: "%.3f", (data?.attitude.roll)!)
                            self.pitch.text = String(format: "%.3f", (data?.attitude.pitch)!)
                            self.yaw.text = String(format: "%.3f", (data?.attitude.yaw)!)
                        }
                    })
                }
            }
            
            csound.play(tempFile)
        } else {
            csound.stop()
            
            if motionManager == csoundMotion.motionManager {
                motionManager.stopAccelerometerUpdates()
                motionManager.stopGyroUpdates()
                motionManager.stopDeviceMotionUpdates()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 220)
        infoText = "Hardware: Motion Control shows how to use the device's motion sensor data as a set of controllers for Csound, and also displays this data in a set of UILabels. Accelerometer X controls oscillator frequency, Attitude: Yaw controls filter cutoff, Attitude: Pitch controls amplitude, and Attitude: Roll controls filter resonance."
        displayInfo(sender)
    }

    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in
            self.mSwitch.isOn = false
        }
    }
}
