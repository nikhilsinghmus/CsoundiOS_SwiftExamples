//
//  ConsoleOutputViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class ConsoleOutputViewController: BaseCsoundViewController, CsoundObjListener, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var renderButton: UIButton!
    @IBOutlet var mTextView: UITextView!
    
    var string: String?
    var csdTable = UITableView()
    
    private var csdArray: [String]?
    private var csdPath: String?
    private var folderPath: String?
    private var csdListVC: UIViewController?
    
    func messageCallback(_ infoObj: NSValue) {
        var info = Message()
        infoObj.getValue(&info)
        let message = UnsafeMutablePointer<Int8>.allocate(capacity: 1024)
        let va_ptr: CVaListPointer = CVaListPointer(_fromUnsafeMutablePointer: &(info.valist))
        vsnprintf(message, 1024, info.format, va_ptr)
        var output = ""
        output = String(cString: message)
        
        DispatchQueue.main.async { [unowned self] in
            self.updateUIWithNewMessage(output)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if csdArray != nil {
            return csdArray!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell")
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if csdArray != nil {
            cell.textLabel?.text = csdArray?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        csdPath = folderPath?.appending((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        csdListVC?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func run(_ sender: UIButton) {
        if sender.isSelected == false {
            mTextView.text = ""
            sender.isSelected = true
            csound.stop()
            csound = CsoundObj()
            csound.setMessageCallback(#selector(messageCallback(_:)), withListener: self)
            csound.add(self)
            if csdPath != nil {
                csound.play(csdPath)
            }
        } else {
            csound.stop()
            sender.isSelected = false
        }
    }
    
    @IBAction func showCSDs(_ sender: UIButton) {
        csdListVC = UIViewController()
        csdListVC?.modalPresentationStyle = .popover
        
        let popover = csdListVC?.popoverPresentationController
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        csdListVC?.preferredContentSize = CGSize(width: 300, height: 600)
        
        csdTable = UITableView(frame: CGRect(x: 0, y: 0, width: (csdListVC?.preferredContentSize.width)!, height:
            (csdListVC?.preferredContentSize.height)!))
        csdTable.delegate = self
        csdTable.dataSource = self
        csdListVC?.view.addSubview(csdTable)
        
        popover?.delegate = self
        if csdListVC != nil {
            present(csdListVC!, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        folderPath = Bundle.main.resourcePath?.appending("/csdStorage/")
        
        if folderPath != nil {
            do {
        csdArray = try FileManager.default.contentsOfDirectory(atPath: folderPath!)
            } catch {
                print(error.localizedDescription)
            }
        }
        csdPath = Bundle.main.path(forResource: "TextOnly - Countdown", ofType: "csd", inDirectory: "csdStorage")
        super.viewDidLoad()
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        infoVC.preferredContentSize = CGSize(width: 300, height: 160)
        infoText = "Renders, by default, a simple 5-second 'countdown' csd and publishes information to a virtual Csound console every second. Click the CSD button on the right to select a different csd file."
        displayInfo(sender)
    }

    func csoundObjCompleted(_ csoundObj: CsoundObj!) {
        DispatchQueue.main.async { [unowned self] in
            self.renderButton.isSelected = false
        }
    }
    
    func updateUIWithNewMessage(_ newMessage: String) {
        mTextView.insertText(newMessage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}