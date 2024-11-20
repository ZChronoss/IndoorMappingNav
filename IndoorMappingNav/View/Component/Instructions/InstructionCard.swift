//
//  InstructionCard.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct InstructionCard: View {
    var icon: String
    var direction: LocalizedStringResource
    var store: String
    
    var isFirst: Bool
    var isLast: Bool
    
    @Binding var focusedCard: Int
    var maxCards: Int
    
    // TODO: Sesuain text dengan direction
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(.title))
                    .bold()
                if isLast {
                    Text("\(direction) and you have arrived at **\(store)**")
                        .font(.system(.subheadline))
                } else {
                    Text("\(direction) and you will see **\(store)**")
                        .font(.system(.subheadline))
                }
            }
            .padding(.horizontal, 24)
            
            if isFirst {
                JumpToEndButton(action: {
                    withAnimation {
                        focusedCard = maxCards - 1
                    }
                })
                .padding(.horizontal, 24)
                    
            }
            
            if isLast {
                RestartButton(action: {
                    withAnimation {
                        focusedCard = 0
                    }
                })
                .padding(.horizontal, 24)
            }
            
        }
        .frame(height: 130)
        .foregroundStyle(.white)
        .background(.blue600)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    @State var focusedCard: Int = 1
    InstructionCard(icon: Directions.straight.icon, direction: Directions.left.instruction, store: "Hai", isFirst: false, isLast: true, focusedCard: $focusedCard, maxCards: 2)
}
