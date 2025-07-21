//
//  FizzyTheme.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-20.
//

import SwiftUI

extension Color {
    static let fizzyTitle = Color.accentColor
    static let fizzyCounter = Color.black.opacity(0.85)
    static let fizzyBubble = Color.white.opacity(0.6)
    
    // Fanta Orange Background
    static let fizzyOrange = Color(red: 1.0, green: 0.55, blue: 0.0)
    
    // Fanta Blue for outlines
    static let fizzyBlue = Color(red: 0.0, green: 0.2, blue: 0.6)
    
    static let fizzyBackground = fizzyOrange
    static let fizzyText = Color.white
}

struct FizzyFont {
    static func title(size: CGFloat = 32) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }

    static func counter(size: CGFloat = 80) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
}
