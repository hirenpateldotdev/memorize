//
//  Cardify.swift
//  Memorize
//
//  Created by Hiren Patel on 6/22/22.
//

import SwiftUI

struct Cardify : AnimatableModifier {
    
    var animatableData: Double {
        get {rotation}
        set {rotation = newValue}
    }
    var rotation: Double
    
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if (rotation < 90) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(.red)
            } else {
                shape.fill().foregroundColor(.red)
            }
            content.opacity((rotation < 90) ? 1 : 0)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (0,1,0))
        
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
