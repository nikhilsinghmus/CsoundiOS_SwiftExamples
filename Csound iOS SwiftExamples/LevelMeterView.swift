//
//  LevelMeterView.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/31/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class LevelMeterView: UIView, CsoundBinding {

    private var channelValue: Float = 0
    private var channelPtr: UnsafeMutablePointer<Float>?
    private var lastY: CGFloat = -100
    private var ksmps = 0
    private var sr = 0
    private var count = 0
    private var count2 = 0
    
    var channelName = ""

    override func draw(_ rect: CGRect) {
        let clipPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        clipPath.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        context?.translateBy(x: 0, y: rect.size.height)
        context?.scaleBy(x: 1, y: -1)
        
        let grayComponents: [CGFloat] = [0.7, 0.7, 0.7, 1.0]
        let grayColor = CGColor(colorSpace: colorSpace, components: grayComponents)
        context?.setFillColor(grayColor!)
        context?.fill(self.bounds)
        
        let width = rect.maxX
        let height = rect.maxY
        let squareWidth = width - 10
        let squareHeight = height/30.0
        
        let greenComponents: [CGFloat] = [0, 1, 0, 1]
        let yellowComponents: [CGFloat] = [221.0/250.0, 223.0/250.0, 14.0/250.0, 1.0]
        let redComponents: [CGFloat] = [1, 0, 0, 1]
        
        let greenColor = CGColor(colorSpace: colorSpace, components: greenComponents)
        let yellowColor = CGColor(colorSpace: colorSpace, components: yellowComponents)
        let redColor = CGColor(colorSpace: colorSpace, components: redComponents)
        
        let x: CGFloat = 12
        
        if lastY < (height * 0.7) {
            context?.setFillColor(greenColor!)
        } else if lastY < (height * 0.9) {
            context?.setFillColor(yellowColor!)
        } else {
            context?.setFillColor(redColor!)
        }
        
        context?.move(to: CGPoint(x: x, y: lastY))
        context?.addLine(to: CGPoint(x: x, y: lastY + squareHeight))
        context?.addLine(to: CGPoint(x: x + squareWidth - 12.0, y: lastY + squareHeight))
        context?.addLine(to: CGPoint(x: x + squareWidth - 12.0, y: lastY))
        context?.fillPath()
        
        var y: CGFloat = 12
        
        while y < (height * CGFloat(channelValue)) {
            
            if (y < (height * 0.7)) {
                    context?.setFillColor(greenColor!)
            } else if ((y < height * 0.9)) {
                    context?.setFillColor(yellowColor!)
            } else {
                    context?.setFillColor(redColor!)
            }
            
            y += squareHeight + 5
            
            context?.move(to: CGPoint(x: x, y: y))
            context?.addLine(to: CGPoint(x: x, y: y + squareHeight))
            context?.addLine(to: CGPoint(x: x + squareWidth - 12.0, y: y + squareHeight))
            context?.addLine(to: CGPoint(x: x + squareWidth - 12.0, y: y))
            context?.fillPath()
        }
        
        if y > lastY {
            lastY = y
        }
        
        if count % 100 == 0 {
            lastY = -squareHeight
        }
        count += 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func add(to csoundObj: CsoundObj, for channel: String) {
        csoundObj.addBinding(self)
        channelName = channel
    }
   
    func setup(_ csoundObj: CsoundObj!) {
        channelPtr = csoundObj.getOutputChannelPtr(channelName, channelType: CSOUND_AUDIO_CHANNEL)
        let cs = csoundObj.getCsound()
        sr = Int(csoundGetSr(cs))
        ksmps = Int(csoundGetKsmps(cs))
    }
    
    func updateValuesFromCsound() {
        if channelPtr != nil {
            channelValue = fabsf((channelPtr?.pointee)!)
        }
        
        if count2 % ((sr/ksmps)/20) == 0 {
            DispatchQueue.main.async { [unowned self] in
                self.setNeedsDisplay()
            }
        }
        count2 += 1
        
        if count2 > Int.max {
            count2 -= Int.max
        }
    }
    
    func cleanup() {
        channelValue = 0
        lastY = -100
        setNeedsDisplay()
    }

}
