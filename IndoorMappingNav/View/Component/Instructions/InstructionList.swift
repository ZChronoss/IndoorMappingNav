//
//  InstructionList.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import SwiftUI

struct InstructionList: View {
    let instructions: [Directions]
    
    @Binding var focusedCard: Int
    
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
        .frame(height: 180)
    }
    
}

//#Preview {
//    InstructionList()
//}
