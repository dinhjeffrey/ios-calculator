//
//  GraphV.swift
//  assignment1-calculator
//
//  Created by jeffrey dinh on 6/16/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit

@IBDesignable
class GraphV: UIView {
    
    @IBInspectable var scale: CGFloat = 1.0 { didSet { setNeedsDisplay() }}
    @IBInspectable var graphOrigin: CGPoint? {didSet { setNeedsDisplay() }}
    @IBInspectable var plotColor: UIColor = UIColor.redColor() {didSet { setNeedsDisplay() }}
    let pointsPerUnit: CGFloat = 50.0
    var minX: CGFloat {
        let minXBound = -(bounds.width - (bounds.width - graphCenter.x))
        return minXBound / (pointsPerUnit * scale)
    }
    var maxX: CGFloat {
        let maxXBound = bounds.width - graphCenter.x
        return maxXBound / (pointsPerUnit * scale)
    }
    var availablePixelsInXAxis: Double {
        return Double(bounds.width * contentScaleFactor)
    }
    
    var graphCenter: CGPoint {
        if graphOrigin == nil {
            graphOrigin = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        return graphOrigin!
    }
    var graphVC = GraphVC()
    private func translatePlot(plot: (x: Double, y: Double)) -> CGPoint { // translates from axes api to human-readable numbers
        let translatedX = CGFloat(plot.x) * pointsPerUnit * scale + graphCenter.x
        let translatedY = CGFloat(-plot.y) * pointsPerUnit * scale + graphCenter.y
        return CGPoint(x: translatedX, y: translatedY)
    }
    
    override func drawRect(rect: CGRect) {
        let axes = AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: contentScaleFactor)
        axes.drawAxesInRect(bounds, origin: graphCenter, pointsPerUnit: pointsPerUnit * scale)
        
        let path = UIBezierPath()
        
        if var plots = graphVC.graphPlot(self) where plots.count != 0 {
            path.moveToPoint(translatePlot((x: plots[0].x , y: plots[0].y)))
            for plot in plots {
                path.addLineToPoint(translatePlot((x: plot.x, y: plot.y)))
            }
        }
        plotColor.set()
        path.stroke()
    }
}
