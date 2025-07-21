//
//  ContentView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-20.
//

import SwiftUI

import SwiftUI

struct FizzyCounterView: View {
    @State private var count = 0

    var body: some View {
        ZStack {
            // Background layer
            Color.fizzyBackground
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                // Title
                Text("FIZZYCOUNTER")
                    .font(FizzyFont.title())
                    .foregroundColor(.fizzyBubble)
                    .offset(x: 0.5, y: 0.5)

                // Counter display
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
                                withAnimation(.spring()) {
                                    count += 1
                                }
                            }

                Spacer()
            }
            .padding()
            .frame(minWidth: 300, minHeight: 400)
        }
    }
}

#Preview {
    FizzyCounterView()
}
