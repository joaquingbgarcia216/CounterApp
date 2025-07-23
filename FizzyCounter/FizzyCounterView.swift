//
//  ContentView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-20.
//

import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    let size: CGFloat // diameter
    var x: CGFloat    // current x-pos
    var y: CGFloat     // current y-pos
}

struct FizzyCounterView: View {
    @State private var count = 0
    @State private var titleText = "FIZZYCOUNTER"
    @State private var bubbles: [Bubble] = []
    
    @FocusState private var isTitleFocused: Bool
    
    // DEBUG
    @State private var titleFrame: CGRect = .zero
    @State private var counterFrame: CGRect = .zero
    
    // set maxTitleLength before warning is displayed
    let maxTitleLength = 20
    let maxCount = 100
   

    var body: some View {
        GeometryReader {geo in
            ZStack {
                // Background layer
                Color.fizzyBackground
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTitleFocused = false
                    }
                
                ForEach(bubbles) {bubble in
                    Circle()
                        .fill(Color.fizzyBubble)
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                }

                VStack(spacing: 12) {
                    // Editable Title
                    TextField("", text: $titleText)
                        .font(FizzyFont.title())
                        .foregroundColor(.fizzyText)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.top)
                        .fixedSize(horizontal: true, vertical: false)
                        .focused($isTitleFocused)
                        // DEBUG
                        .background(
                            GeometryReader { proxy in
                                let frame = proxy.frame(in: .named("container"))
                                Color.clear
                                .onAppear     { titleFrame = frame }
                                .onChange(of: frame) { titleFrame = $0 }
                                
                            }
                        )
                    

                    // Warning
                    if titleText.count >= maxTitleLength {
                        Text("Max \(maxTitleLength) characters reached.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("pour?") {
                        isTitleFocused = false
                        pour(in: geo.size)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.caption)
                    .foregroundColor(.fizzyText.opacity(0.7))
                    .padding(.top, 4)
                    
                    // Counter
                    Text(String(format: "%02d", count))
                        .font(FizzyFont.counter())
                        .foregroundColor(.fizzyText)
                        .overlay(
                            Text(String(format: "%02d", count))
                                .font(FizzyFont.counter())
                                .foregroundColor(.fizzyBubble)
                                .offset(x: 0.5, y: 0.5)
                        )
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(
                            GeometryReader { proxy in
                                let frame = proxy.frame(in: .named("container"))
                                Color.clear
                                    .onAppear     { counterFrame = frame }
                                    .onChange(of: frame) { counterFrame = $0 }
                            }
                            
                        )
                        .cornerRadius(20)
                        .onTapGesture {
                            guard count < maxCount else { return }
                            isTitleFocused = false
                            // increment the counter
                            withAnimation(.spring()) {
                                count += 1
                            }
                            
                            // spawn a new bubble
                            let diameter = CGFloat.random(in: 20...40)
                            let radius = diameter / 2
                            let startX = CGFloat.random(
                                in: diameter/2 ... geo.size.width - diameter/2
                            )
                            let startY = geo.size.height + diameter/2
                            let newBubble = Bubble(size: diameter, x: startX, y: startY)
                            bubbles.append(newBubble)
                            guard let idx = bubbles.firstIndex(where: { $0.id == newBubble.id }) else { return }
                            
                            // Dynamic Frame Dimensions
                            let titleMinX = titleFrame.minX
                            let titleMaxX = titleFrame.maxX
                            let titleBottomY = titleFrame.maxY
                            
                            let counterMinX  = counterFrame.minX
                            let counterMaxX  = counterFrame.maxX
                            let counterBottomY = counterFrame.maxY
                            
                            let overlapsTitleX =
                            (newBubble.x + radius) > titleMinX &&    // bubble’s right edge past title’s left
                            (newBubble.x - radius) < titleMaxX       // bubble’s left edge before title’s right
                            let overlapsCounterX = (newBubble.x + radius) > counterMinX
                            && (newBubble.x - radius) < counterMaxX
                            
                            let finalY: CGFloat
                            if overlapsCounterX {
                                finalY = CGFloat.random(in: counterBottomY + radius...geo.size.height - radius)
                            } else if overlapsTitleX {
                                finalY = CGFloat.random(in: titleBottomY + radius...geo.size.height - radius)
                            } else {
                                finalY = CGFloat.random(in: radius...geo.size.height - radius)
                            }
                            
                            // animate rise
                            guard count < maxCount else {return}
                            let riseDuration = 1.5
                            
                            DispatchQueue.main.async {
                                // Rise to initial finalY
                                withAnimation(.easeOut(duration: riseDuration)) {
                                    bubbles[idx].y = finalY
                                }
                                                                
                            }
                            
                        }
                    
                    Spacer()
                }
            }
            .coordinateSpace(name: "container")
            
            .frame(minWidth: 300, minHeight: 400)
            
        }

        
        
        .onAppear {
            // ensure the title field is NOT focused when the window appears
            DispatchQueue.main.async {
                isTitleFocused = false
            }
        }
        
    }
    
    
    
    // Pour all existing bubbles on the screen
    private func pour(in size: CGSize) {
        withAnimation(.spring()) {
            count = 0
        }
        
        let bottomY = size.height + 50
        let minSize: CGFloat = 20
        let maxSize: CGFloat = 40
        let minDur: Double = 0.5
        let maxDur: Double = 2.0
        
        for idx in bubbles.indices {
            let size = bubbles[idx].size
            let norm = (size - minSize) / (maxSize - minSize)
            let dur = maxDur - norm * (maxDur - minDur)
            
            withAnimation(.easeIn(duration: dur)) {
                bubbles[idx].y = bottomY
            }
        }
    }
}
#Preview {
    FizzyCounterView()
}
