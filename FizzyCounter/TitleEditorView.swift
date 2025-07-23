//
//  TitleEditorView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-21.
//

import SwiftUI

struct TitleEditorView: View {
    @Binding var titleText  : String
    @Binding var titleFrame : CGRect
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        TextField("", text: $titleText)
            .font(FizzyFont.title())
            .foregroundColor(.fizzyText)
            .multilineTextAlignment(.center)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.top)
            .fixedSize(horizontal: true, vertical: false)
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
    }
}
