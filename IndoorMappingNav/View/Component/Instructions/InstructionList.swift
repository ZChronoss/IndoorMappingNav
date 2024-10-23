//
//  InstructionList.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import SwiftUI

struct InstructionList: View {
    let instructions: [Directions] = [
        LeftDirection(),
        StraightDirections(),
        RightDirection()
    ]
    
    @State private var focusedCard: Int = 0
    
    var body: some View {
        TabView(selection: $focusedCard) {
            ForEach(0 ..< instructions.count, id: \.self ) { idx in
                InstructionCard(
                    icon: instructions[idx].icon,
                    direction: instructions[idx].instruction,
                    isFirst: instructions[idx].id == instructions.first?.id,
                    isLast: instructions[idx].id == instructions.last?.id,
                    focusedCard: $focusedCard,
                    maxCards: instructions.count)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
    
}

#Preview {
    InstructionList()
}
