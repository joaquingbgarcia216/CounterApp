//
//  ContentView.swift
//  CounterApp
//
//  Created by Joaquin Garcia on 2025-07-20.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    var body: some View {
        VStack(spacing: 20) { // Vertical stack with line spacing 20
            // Counter Display
            Text("Count: \(count)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .padding()
            // Horizontal Row of Buttons
            HStack(spacing: 20) {
                Button("-") {
                    count -= 1
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Reset") {
                    count = 0
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("+") {
                    count += 1
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .frame(minWidth: 300, minHeight: 200)
        }
        
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .semibold))
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.accentColor.opacity(configuration.isPressed ? 0.6 : 0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
