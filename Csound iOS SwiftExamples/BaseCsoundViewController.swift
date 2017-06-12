//
//  BaseCsoundViewController.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/29/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class BaseCsoundViewController: UIViewController, UISplitViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    var infoText = ""
    var infoVC = UIViewController()
    
    var csound = CsoundObj()
    var detailItem: AnyObject? {
        didSet(newDetailItem) {
            configureView()
            
            if masterPopoverController != nil {
                masterPopoverController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    var detailDescriptionLabel: UILabel!
    var masterPopoverController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        csound.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        if detailItem != nil {
            detailDescriptionLabel.text = detailItem?.description
        }
    }
    
    func displayInfo(_ sender: UIButton) {
        infoVC.modalPresentationStyle = .popover
        
        
        let infoTextView = UITextView(frame: CGRect(x: 0, y: 0, width: infoVC.preferredContentSize.width, height: infoVC.preferredContentSize.height))
        infoTextView.isEditable = false
        infoTextView.isSelectable = false

        infoTextView.attributedText = NSAttributedString(string: infoText)
        infoTextView.font = UIFont(name: "Menlo", size: 16)
        
        let popover = infoVC.popoverPresentationController
        infoVC.view.addSubview(infoTextView)
        popover?.delegate = self
        popover?.permittedArrowDirections = .up
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        present(infoVC, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .popover
    }
    
    
    // MARK: Init
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Split View
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem;
        navigationItem.leftBarButtonItem?.title = "Csound for iOS"
        masterPopoverController = svc
    }
    
    func splitViewController(_ svc: UISplitViewController, willShow aViewController: UIViewController, invalidating barButtonItem: UIBarButtonItem) {
        
    }

}
