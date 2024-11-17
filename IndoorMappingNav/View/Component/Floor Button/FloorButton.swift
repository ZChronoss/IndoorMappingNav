//
//  FloorButton.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct FloorButton: View {
    @State var btnLbl: String = "1"
    @State private var didTap = false
    
    // TODO: bikin buat yang jumlah konten itu
    @State var contentNum: Int = 0
    
    
    // Buat kasih tau active floor yang mana
    @Binding var activeFloor: String
    
    var body: some View {
        Button {
            didTap.toggle()
            
            // buat toggle floor yang mana juga
            activeFloor = btnLbl
        } label: {
            // callout has the same property as floor button except its weight
            Text(btnLbl)
                .font(.system(.callout, weight: .semibold))
                .padding(12)
                .frame(width: 50, height: 50)
        }
        .foregroundStyle(activeFloor == btnLbl ? .white : .secondaryAlt)
        .background(activeFloor == btnLbl ? .blue600 : .backgroundSecondary)
        .clipShape(.circle)
        .frame(width: 50, height: 50)
        .animation(.easeOut, value: didTap)
        .customBadge(5, color: .toilet)
    }
}

#Preview {
//    FloorButton()
}
