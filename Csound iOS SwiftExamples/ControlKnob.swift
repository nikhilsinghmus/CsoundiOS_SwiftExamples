//
//  ControlKnob.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 6/2/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class ControlKnob: UIControl, CsoundBinding {
    
    private var _value: Float32 = 1.0
    var value: Float32 {
        set {
            self._value = newValue
            angle = CGFloat(_value/maximumValue) * 270.0
        }
        get { return self._value }
    }
    var defaultValue: Float32 = 1.0
    var minimumValue: Float32 = 0.5
    var maximumValue: Float32 = 2.0
    
    private var channelValue: Float = 0
    private var channelPtr: UnsafeMutablePointer<Float>?
    private var angle: CGFloat = 0
    private var lastTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    // MARK: UIControl overrides
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return tracking(touch)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return tracking(touch)
    }
    
    private func tracking(_ touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: superview)
        if touchPoint.y < lastTouchPoint.y {
            angle += angle < 270 ? 5 : 0
        } else {
            angle -= angle > 0 ? 5 : 0
        }
        _value = minimumValue + Float32(angle/270.0) * (maximumValue - minimumValue)
        
        lastTouchPoint = touchPoint
        setNeedsDisplay()
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func cancelTracking(with event: UIEvent?) { }
    
    // MARK: Drawing
    override func draw(_ rect: CGRect) {
        transform = CGAffineTransform(rotationAngle: (angle * .pi)/180.0)
        if angle >= 360 {
            angle -= 360
        }
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        context?.translateBy(x: 0, y: rect.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        let redComponents: [CGFloat] = [1, 0.1, 0, 1]
        let redColor = CGColor(colorSpace: colorSpace, components: redComponents)
        context?.setFillColor(redColor!)
        context?.addEllipse(in: rect)
        context?.fillEllipse(in: rect)
        
        context?.move(to: CGPoint(x: rect.size.width/4.0, y: rect.size.height/4.0))
        context?.addLine(to: CGPoint(x: rect.size.width/2.0, y: rect.size.height/2.0))
        let blackComponents: [CGFloat] = [0, 0, 0, 1]
        let blackColor = CGColor(colorSpace: colorSpace, components: blackComponents)
        context?.setStrokeColor(blackColor!)
        context?.strokePath()
    }
    
    // MARK: Csound Binding
    func setup(_ csoundObj: CsoundObj!) {
        channelPtr = csoundObj.getInputChannelPtr("pitch", channelType: CSOUND_CONTROL_CHANNEL)
        channelValue = _value
        addTarget(self, action: #selector(updateChannelValue(_:)), for: .valueChanged)
    }
    
    @objc func updateChannelValue(_ sender: ControlKnob) {
        channelValue = sender._value
    }
    
    func updateValuesToCsound() {
        channelPtr?.pointee = channelValue
    }
}
