//
//  PourButtonView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-21.
//

import SwiftUI

struct PourButtonView: View {
    let action: ()->Void
    var body: some View {
        Button("pour?") { action() }
            .buttonStyle(PlainButtonStyle())
            .font(.caption)
            .foregroundColor(.fizzyText.opacity(0.7))
            .padding(.top, 4)
    }
}
