//
//  FloorButtons.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 19/10/24.
//

import SwiftUI

struct FloorButtons: View {
    let floors: [String] = [
        "2",
        "1",
        "GF"
    ]
    
    @State var activeFloor: String = "GF"
    
    
    var body: some View {
        VStack(spacing: 16){
            ForEach(floors, id: \.self) { floor in
                FloorButton(btnLbl: floor, activeFloor: $activeFloor)
                    
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 18)
        .background(.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 29.5))
    }
}

#Preview {
    FloorButtons()
}
