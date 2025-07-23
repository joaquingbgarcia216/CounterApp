//
//  Bubble.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-21.
//

import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    let size: CGFloat // diameter
    var x: CGFloat    // current x-pos
    var y: CGFloat     // current y-pos
}
