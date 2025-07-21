//
//  ContentView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-20.
//

import SwiftUI

struct FizzyCounterView: View {
    @State private var count = 0
    @State private var titleText = "FIZZYCOUNTER"
    
    let maxTitleLength = 20

    var body: some View {
        ZStack {
            // Background layer
            Color.fizzyBackground
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                // Editable Title
                TextField("", text: $titleText)
                    .font(FizzyFont.title())
                    .foregroundColor(.fizzyText)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.top)
                    .fixedSize(horizontal: true, vertical: false)

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
