//
//  ContentView.swift
//  FizzyCounter
//
//  Created by Joaquin Garcia on 2025-07-20.
//

import SwiftUI

struct FizzyCounterView: View {
    @StateObject private var vm = FizzyCounterViewModel()
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.fizzyBackground
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { isTitleFocused = false }
                
                BubbleContainerView(bubbles: $vm.bubbles)
                
                VStack(spacing: 12) {
                    TitleEditorView(
                        titleText: $vm.titleText,
                        titleFrame: $vm.titleFrame,
                        isFocused: $isTitleFocused
                    )
                    
                    CounterDisplayView(
                        count: $vm.count,
                        counterFrame: $vm.counterFrame
                    ) {
                        vm.spawnBubble(in: geo.size)
                        if vm.count >= vm.maxCount {
                            vm.pourAll(in: geo.size)
                        }
                    }
                    
                    PourButtonView {
                        vm.pourAll(in: geo.size)
                    }
                    
                    Spacer()
                }
                .coordinateSpace(name: "container") // one shared space
                .padding()
                .frame(minWidth: 300, minHeight: 400)
            }
        }
        .onAppear {
            isTitleFocused = false
        }
    }
}

#Preview {
    FizzyCounterView()
}
