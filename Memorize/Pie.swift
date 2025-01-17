//
//  Pie.swift
//  Memorize
//
//  Created by Hiren Patel on 6/22/22.
//

import SwiftUI

struct Pie: Shape {
    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    var startAngle : Angle
    var endAngle : Angle
    var clockwise = false
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.height, rect.width) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat( cos(startAngle.radians) ),
            y: center.y + radius * CGFloat( sin(startAngle.radians) )
        )
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        p.addLine(to: center)
        return p
    }
    
    
}
