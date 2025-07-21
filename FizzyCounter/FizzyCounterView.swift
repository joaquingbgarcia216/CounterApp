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
   

    var body: some View {
        GeometryReader {geo in
            ZStack {
                // Background layer
                Color.fizzyBackground
                    .edgesIgnoringSafeArea(.all)
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red, lineWidth: 2)
                        )
                    
                    /// DEBUG x and width
                    Text("X: \(Int(titleFrame.origin.x)), W: \(Int(titleFrame.size.width))")
                        .font(.caption2)
                        .foregroundColor(.white)


                    // Warning
                    if titleText.count >= maxTitleLength {
                        Text("Max \(maxTitleLength) characters reached.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

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
                                Color.fizzyOrange.opacity(0.7)
                                .onAppear     { counterFrame = frame }
                                .onChange(of: frame) { counterFrame = $0 }
                                
                            }
                            
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .cornerRadius(20)
                        .onTapGesture {
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
                        
                            // ───── DYNAMIC TITLE FRAME USAGE ─────
                                // (you measured titleFrame.origin.x == 239, width == 254)
                                let titleMinX = titleFrame.minX         // 239
                                let titleMaxX = titleFrame.maxX         // 239 + 254 = 493
                                let titleBottomY = titleFrame.maxY      // whatever you measured for Y + height
                            
                                // Counter frame values (from your measured counterFrame)
                                let counterMinX  = counterFrame.minX
                                let counterMaxX  = counterFrame.maxX
                                let counterBottomY = counterFrame.maxY

                                // 3️⃣ compute the two candidate Y’s
                                let topY  = radius
                                let stopYTitle = titleBottomY + radius          // sit just under the title block
                                let stopYCounter = counterBottomY + radius

                                // 4️⃣ only clamp under the title if horizontally overlapping
                                let overlapsTitleX =
                                    (newBubble.x + radius) > titleMinX &&    // bubble’s right edge past title’s left
                                    (newBubble.x - radius) < titleMaxX       // bubble’s left edge before title’s right
                                let overlapsCounterX = (newBubble.x + radius) > counterMinX
                                                    && (newBubble.x - radius) < counterMaxX

                                let finalY: CGFloat
                                    if overlapsCounterX {
                                      finalY = stopYCounter
                                    } else if overlapsTitleX {
                                      finalY = stopYTitle
                                    } else {
                                      finalY = topY
                                    }

                            // old targetY
                            // let targetY = diameter/2
                            
                            // animate rise
                            DispatchQueue.main.async {
                                withAnimation(.easeOut(duration: 2.0)) {
                                    bubbles[idx].y = finalY
                                }
                            }
                            
                            // then resolve collisions
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
//                                    resolveCollisions(in: geo.size.width)
//                                }
//                            }
                            
                        }
                    
                    Button("pour?") {
                        isTitleFocused = false
                        
                        withAnimation(.spring()) {
                            count = 0
                        }
                        
                        let bottomY = geo.size.height + 50
                        
                        let minSize: CGFloat = 20
                        let maxSize: CGFloat = 40
                        let minDur: Double = 0.5
                        let maxDur: Double = 2.0
                        
                        DispatchQueue.main.async {
                            for idx in bubbles.indices {
                                let size = bubbles[idx].size
                                let norm = (size - minSize) / (maxSize - minSize)
                                let dur = maxDur - norm * (maxDur - minDur)
                            
                                withAnimation(.easeIn(duration: dur)) {
                                    bubbles[idx].y = bottomY
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + maxDur) {
                                bubbles.removeAll()
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.caption)
                    .foregroundColor(.fizzyText.opacity(0.7))
                    .padding(.top, 4)
                    
                    

                    Spacer()
                }
        }
            .coordinateSpace(name: "container")
            .padding()
            .frame(minWidth: 300, minHeight: 400)
        }
        
        .coordinateSpace(name: "container")
        
        .onAppear {
            // ensure the title field is NOT focused when the window appears
            DispatchQueue.main.async {
                isTitleFocused = false
            }
        }
    }
    
    // Push any overlapping bubbles apart horizontally, pair by pair.
    func resolveCollisions(in width: CGFloat) {
        let count = bubbles.count
        for i in 0..<count {
            for j in (i+1)..<count {
                let b1 = bubbles[i], b2 = bubbles[j]
                let dx = b2.x - b1.x
                let overlap = (b1.size + b2.size)/2 - abs(dx)
                guard overlap > 0 else {continue}
                
                let shift = overlap / 2
                if dx > 0 {
                    bubbles[i].x -= shift
                    bubbles[j].x += shift
                } else {
                    bubbles[i].x += shift
                    bubbles[j].x -= shift
                }
            }
        }
        for idx in bubbles.indices {
            let r = bubbles[idx].size/2
            bubbles[idx].x = min(max(bubbles[idx].x, r), width - r)
        }
    }
}

#Preview {
    FizzyCounterView()
}
