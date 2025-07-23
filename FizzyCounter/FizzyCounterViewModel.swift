//
//  FizzyCounterViewModel.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-21.
//

import SwiftUI
import Combine

class FizzyCounterViewModel: ObservableObject {
    // State
    @Published var count = 0
    @Published var titleText = "FIZZYCOUNTER"
    @Published var bubbles: [Bubble] = []
    @Published var titleFrame: CGRect = .zero
    @Published var counterFrame: CGRect = .zero
    
    // Configuration
    let maxCount       = 100
    let minBubbleSize : CGFloat = 20
    let maxBubbleSize  : CGFloat = 40
    
    // called when the user taps the counter
    func spawnBubble(in containerSize: CGSize) {
        incrementCount()
        let bubble = createBubble(in: containerSize)
        append(bubble)
        scheduleRise(of: bubble, in: containerSize)
    }
    
    // called when the pour? button is pressed or maxCount is reached
    func pourAll(in containerSize: CGSize) {
        resetCount()
        animateDrain(in: containerSize)
    }
    
    // Count Helpers
    func incrementCount() {
        count += 1
    }
    
    func resetCount() {
        count = 0
    }
    
    // Bubble Creation
    private func createBubble(in size: CGSize) -> Bubble {
        let diameter = CGFloat.random(in: minBubbleSize...maxBubbleSize)
        let radius = diameter / 2
        let startX = CGFloat.random(in: radius ... size.width - radius)
        let startY = size.height + radius
        return Bubble(size: diameter, x: startX, y:startY)
    }
    
    private func append(_ bubble: Bubble) {
        bubbles.append(bubble)
    }
    
    // Bubble Rise
    private func scheduleRise(of bubble: Bubble, in size: CGSize) {
        guard let idx = index(of: bubble) else { return }
        let finalY = calculateFinalY(for: bubbles[idx])
        animateRise(of: idx, to: finalY, in: size.width)
    }
    
    private func calculateFinalY(for bubble: Bubble) -> CGFloat {
        let radius     = bubble.size / 2
        let topY       = radius
        let stopTitle  = titleFrame.maxY + radius
        let stopCount  = counterFrame.maxY + radius
        
        let rightEdge = bubble.x + radius
        let leftEdge = bubble.x - radius
        
        let overlapsTitle   = rightEdge >= titleFrame.minX && leftEdge  <= titleFrame.maxX
        let overlapsCounter = rightEdge >= counterFrame.minX && leftEdge  <= counterFrame.maxX
        
        if overlapsCounter  {
            return stopCount
        } else if overlapsTitle  {
            return stopTitle
        } else {
            return topY
        }
    }
    
//    private func bubbleOverlaps(frame: CGRect, bubble: Bubble) -> Bool {
//        let radius = bubble.size / 2
//        return (bubble.x + radius) > frame.minX && (bubble.x - radius) < frame.maxX
//    }
    
    private func animateRise(of idx: Int, to finalY: CGFloat, in width: CGFloat) {
        let duration: TimeInterval = 2.0
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: duration)) {
                self.bubbles[idx].y = finalY
            }
        }
    }
    
    private func index(of bubble: Bubble) -> Int? {
        bubbles.firstIndex(where: { $0.id == bubble.id })
    }
    
    // Bubble Drain
    private func animateDrain(in size: CGSize) {
        let bottomY = size.height + 50
        for i in bubbles.indices {
            let dur = drainDuration(for: bubbles[i].size)
            withAnimation(.easeIn(duration: dur)) {
                bubbles[i].y = bottomY
            }
        }
        // clear after longest duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.bubbles.removeAll()
        }
    }
    
    private func drainDuration(for size: CGFloat) -> TimeInterval {
        let norm = (size - minBubbleSize) / (maxBubbleSize - minBubbleSize)
        return 2.0 - norm * 1.5
    }
    
    // Collision Resolution
    private func resolveCollisions(in width: CGFloat) {
        // todo
    }
    
    private func clampBubbles(to width: CGFloat) {
        // todo
    }
    
}
