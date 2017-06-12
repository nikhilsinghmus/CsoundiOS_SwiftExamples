//
//  ControlXYGrid.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/31/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit


class ControlXYGrid: UIControl, CsoundBinding {
    
    private var xValue: Float = 0
    private var yValue: Float = 0
    private var xChannelValue: Float = 0
    private var yChannelValue: Float = 0
    private var xChannelPtr: UnsafeMutablePointer<Float>?
    private var yChannelPtr: UnsafeMutablePointer<Float>?
    private var borderWidth: CGFloat = 10
    private var circleRect = CGRect()
    private var shouldTrack = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        circleRect = CGRect(x: borderWidth, y: frame.size.height - 30.0 - borderWidth, width: 30.0, height: 30.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        circleRect = CGRect(x: borderWidth, y: frame.size.height - 30.0 - borderWidth, width: 30.0, height: 30.0)
    }
    
    func setXValue(_ value: CGFloat) {
        let maxX = frame.size.width - borderWidth - circleRect.size.width
        
        let xPosition: CGFloat = value * (maxX - borderWidth)
        circleRect.origin.x = xPosition * borderWidth
        
        setNeedsDisplay()
        sendActions(for: .valueChanged)
    }
    
    
    func setYValue(_ value: CGFloat) {
        xValue = Float(value)
        
        let maxY = frame.size.height - borderWidth - circleRect.size.height
        
        let yPosition = value * (maxY - borderWidth)
        circleRect.origin.y = yPosition
        
        setNeedsDisplay()
        sendActions(for: .valueChanged)
    }
    
    func setCircleDiameter(_ diameter: CGFloat) {
        circleRect = CGRect(x: borderWidth, y: frame.size.height - diameter - borderWidth, width: diameter, height: diameter)
        setNeedsDisplay()
    }
    
    // MARK: UIControl Overrides
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var location = touch.location(in: self)
        
        location.x -= circleRect.size.width/2.0
        location.y -= circleRect.size.height/2.0
            
        let maxX = frame.size.width - borderWidth - circleRect.size.width
        let maxY = frame.size.height - borderWidth - circleRect.size.height
            
        let minX = borderWidth, minY = borderWidth
            
        location.x = location.x < minX ? minX : location.x
        location.y = location.y < minY ? minY : location.y
        location.x = location.x > maxX ? maxX : location.x
        location.y = location.y > maxY ? maxY : location.y
            
        circleRect.origin.x = location.x
        circleRect.origin.y = location.y

        xValue = Float(location.x/maxX)
        yValue = Float(1 - location.y/maxY)
        
        shouldTrack = true
        
        setNeedsDisplay()
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var location = touch.location(in: self)
        
        if shouldTrack {
            location.x -= circleRect.size.width/2.0
            location.y -= circleRect.size.height/2.0
            
            let maxX = frame.size.width - borderWidth - circleRect.size.width
            let maxY = frame.size.height - borderWidth - circleRect.size.height
            
            let minX = borderWidth, minY = borderWidth
            
            location.x = location.x < minX ? minX : location.x
            location.y = location.y < minY ? minY : location.y
            location.x = location.x > maxX ? maxX : location.x
            location.y = location.y > maxY ? maxY : location.y
            
            circleRect.origin.x = location.x
            circleRect.origin.y = location.y
            
            xValue = Float(location.x/maxX)
            yValue = Float(1 - location.y/maxY)
        }
        
        setNeedsDisplay()
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shouldTrack = false
    }
    

    override func draw(_ rect: CGRect) {
        let clipPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        clipPath.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        
        UIColor.black.set()
        context?.setLineWidth(borderWidth * 2.0)
        context?.setLineJoin(.round)
        
        let borderPath = CGMutablePath()
        borderPath.move(to: CGPoint(x: 0, y: 0))
        borderPath.addLine(to: CGPoint(x: 0, y: rect.size.height))
        borderPath.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        borderPath.addLine(to: CGPoint(x: rect.size.width, y: 0))
        borderPath.addLine(to: CGPoint(x: 0, y: 0))
        context?.addPath(borderPath)
        context?.drawPath(using: .stroke)
        
        context?.addEllipse(in: circleRect)
        context?.fillEllipse(in: circleRect)
    }
    
    func setup(_ csoundObj: CsoundObj!) {
        xChannelPtr = csoundObj.getInputChannelPtr("mix", channelType: CSOUND_CONTROL_CHANNEL)
        yChannelPtr = csoundObj.getInputChannelPtr("pitch", channelType: CSOUND_CONTROL_CHANNEL)
        
        xChannelValue = xValue
        yChannelValue = yValue
        
        addTarget(self, action: #selector(updateChannelValues(_:)), for: .valueChanged)
    }
    
    @objc func updateChannelValues(_ sender: AnyObject) {
        if sender is ControlXYGrid {
            let XYGrid = sender as! ControlXYGrid
            xChannelValue = XYGrid.xValue
            yChannelValue = XYGrid.yValue
        }
    }
    
    func updateValuesToCsound() {
        xChannelPtr?.pointee = xChannelValue
        yChannelPtr?.pointee = yChannelValue
    }
    
    func cleanup() {
        removeTarget(self, action: #selector(updateChannelValues(_:)), for: .valueChanged)
    }
}
