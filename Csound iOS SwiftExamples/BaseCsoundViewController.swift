//
//  BaseCsoundViewController.swift
//  Csound iOS SwiftExamples
//
//  Nikhil Singh, Dr. Richard Boulanger
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

// Define base class for all examples
class BaseCsoundViewController: UIViewController, UISplitViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    var infoText = ""
    var infoVC = UIViewController()
    var csound = CsoundObj()    // CsoundObj() property inherited by all examples
    
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationItem.leftBarButtonItem = splitViewController?.navigationItem.leftBarButtonItem
        }
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
    
    // Method to display information in a popover, called from each inheriting class
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
    
    // MARK: UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none    // Ensure infoVC presents as popover on iPhone
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
