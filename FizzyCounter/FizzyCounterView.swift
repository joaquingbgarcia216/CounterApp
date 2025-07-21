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
    var y:CGFloat     // current y-pos
}

struct FizzyCounterView: View {
    @State private var count = 0
    @State private var titleText = "FIZZYCOUNTER"
    @State private var bubbles: [Bubble] = []
    @FocusState private var isTitleFocused: Bool
    
    let maxTitleLength = 20

    var body: some View {
        GeometryReader {geo in
            ZStack {
                // Background layer
                Color.fizzyBackground
                    .edgesIgnoringSafeArea(.all)
                
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
                        .background(Color.fizzyOrange.opacity(0.7))
                        .cornerRadius(20)
                        .onTapGesture {
                            // increment the counter
                            withAnimation(.spring()) {
                                count += 1
                            }
                            
                            // spawn a new bubble
                            let diameter = CGFloat.random(in: 20...40)
                            let startX = CGFloat.random(
                                    in: diameter/2 ... geo.size.width - diameter/2
                                    )
                            let startY = geo.size.height + diameter/2
                            let newBubble = Bubble(size: diameter, x: startX, y: startY)
                            bubbles.append(newBubble)
                            
                            // animate it to the "top", 20 pts from top edge
                            DispatchQueue.main.async {
                                withAnimation(.easeOut(duration: 2)) {
                                    if let idx = bubbles.firstIndex(where: { $0.id == newBubble.id }) {
                                        bubbles[idx].y = diameter/2 + 20
                                    }
                                }
                            }
                        }

                    Spacer()
                }
        }
        
            .padding()
            .frame(minWidth: 300, minHeight: 400)
        }
        .onAppear {
            // ensure the title field is NOT focused when the window appears
            DispatchQueue.main.async {
                isTitleFocused = false
            }
        }
    }
}

#Preview {
    FizzyCounterView()
}
