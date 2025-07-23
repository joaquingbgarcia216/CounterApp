//
//  BubbleContainerView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-21.
//

import SwiftUI

struct BubbleContainerView: View {
    @Binding var bubbles: [Bubble]
    
    var body: some View {
        ForEach(bubbles) { bubble in
            Circle()
                .fill(Color.fizzyBubble)
                .frame(width: bubble.size, height: bubble.size)
                .position(x: bubble.x, y: bubble.y)
        }
    }
}
