//
//  Instruction Card.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct Instruction_Card: View {
    @State var direction: Directions = .straight
    
    
    // TODO: Sesuain text dengan direction
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: direction.rawValue)
                    .font(.system(.title, weight: .bold))
                Text("Keep going straight and you will see Starbucks")
                    .font(.system(.subheadline, weight: .bold))
            }
            .padding(24)
        }
        .background(.blue600)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

enum Directions: String {
    case left = "arrow.left"
    case right = "arrow.right"
    case straight = "arrow.up"
    case stairUp = "figure.stairs"
    case here = "mappin.and.ellipse"
}

#Preview {
    Instruction_Card()
}
