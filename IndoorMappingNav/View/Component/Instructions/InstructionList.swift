//
//  InstructionList.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import SwiftUI

struct InstructionList: View {
    let instructions: [Directions]
    @State private var focusedCard: Int = 0
    
    var body: some View {
        TabView(selection: $focusedCard) {
            ForEach(instructions) { instruction in
                InstructionCard(icon: instruction.icon, direction: instruction.instruction)
//                    .scaledToFill()
                    .containerRelativeFrame(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
    
}

#Preview {
    InstructionList(instructions: [
        LeftDirection(),
        StraightDirections(),
        RightDirection()
    ])
}
