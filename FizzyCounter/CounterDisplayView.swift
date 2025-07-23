//
//  CounterDisplayView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-21.
//

import SwiftUI

struct CounterDisplayView: View {
    @Binding var count        : Int
    @Binding var counterFrame : CGRect
    let   onTap              : () -> Void
    
    var body: some View {
        
        Text(String(format: "%02d", count))
            .font(FizzyFont.counter())
            .foregroundColor(.fizzyText)
            .overlay(
                Text(String(format: "%02d", count))
                    .font(FizzyFont.counter())
                    .foregroundColor(.fizzyBubble)
                    .offset(x:0.5, y:0.5)
            )
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .cornerRadius(20)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
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
    }
}
