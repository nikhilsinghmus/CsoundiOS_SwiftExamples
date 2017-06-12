//
//  Waveview.swift
//  Csound iOS SwiftExamples
//
//  Created by Nikhil Singh on 5/31/17.
//  Adapted from the Csound iOS Examples by Steven Yi and Victor Lazzarini

import UIKit

class Waveview: UIView, CsoundBinding {
    
    private var tableLoaded = false
    private var lastY: CGFloat = 0
    private var csObj = CsoundObj()
    private var table: UnsafeMutablePointer<Float>?
    private var tableLength = 0
    private lazy var displayData = [Float]()
    private var fTableNumber = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        displayData = [Float](repeatElement(Float(0), count: Int(frame.width)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        displayData = [Float](repeatElement(Float32(0), count: Int(frame.width)))
    }
    
    func displayFTable(_ fTableNum: Int) {
        fTableNumber = fTableNum
        tableLoaded = false
        self.updateValuesFromCsound()
    }
    
    func ptoa(_ ptr: UnsafeMutablePointer<Float>, length: Int) -> [Float] {
        let bfr = UnsafeBufferPointer(start: ptr, count: length)
        return [Float](bfr)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(rect)
        
        if tableLoaded {
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.setFillColor(UIColor.white.cgColor)
            let fill_path = CGMutablePath()
            let x: CGFloat = 0
            let y: CGFloat = CGFloat(displayData[0])
            
            fill_path.move(to: CGPoint(x: x, y: y), transform: .identity)
            
            for i in 0 ..< displayData.count {
                fill_path.addLine(to: CGPoint(x: CGFloat(i), y: CGFloat(displayData[i])), transform: .identity)
            }
            
            context?.addPath(fill_path)
            context?.setAllowsAntialiasing(true)
            context?.drawPath(using: .stroke)
        }
    }
    
    private func updateDisplayData() {
        let scalingFactor: Float32 = 0.9
        let width = self.frame.size.width
        let height = self.frame.size.height
        let middle: Float32 = Float32(height / 2.0)
        
        if table != nil {
            let valTable = ptoa(table!, length: tableLength)
            displayData = [Float](repeatElement(Float(0), count: Int(width)))
            
            for i in 0 ..< displayData.count {
                let percent: Float = Float(i)/Float(width)
                let index: Int = Int(percent * Float(tableLength))
                if table != nil {
                    displayData[i] = (-(valTable[index] * middle * scalingFactor) + middle)
                }
            }
        }

        DispatchQueue.main.async { [unowned self] in
            self.setNeedsDisplay()
        }
    }
    
    func setup(_ csoundObj: CsoundObj!) {
        tableLoaded = false
        csObj = csoundObj
        fTableNumber = 1
    }
    
    func updateValuesFromCsound() {
        if !tableLoaded {
            let cs = csObj.getCsound()
            tableLength = Int(csoundTableLength(cs, Int32(fTableNumber)))
            if tableLength > 0 {
                table = UnsafeMutablePointer<Float>.allocate(capacity: tableLength)
                csoundGetTable(cs, &table, Int32(fTableNumber))
                tableLoaded = true
            }
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                self.updateDisplayData()
            }
        }
    }
}
