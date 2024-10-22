//
//  InstructionCard.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct InstructionCard: View {
    var icon: String
    var direction: AttributedString
    
    // TODO: Sesuain text dengan direction
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(.title))
                    .bold()
                Text("\(direction) and you will see **Starbucks**")
                    .font(.system(.subheadline))
            }
            .padding(24)
        }
        .background(.blue600)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    InstructionCard(icon: Directions.straight.icon, direction: Directions.left.instruction)
}
