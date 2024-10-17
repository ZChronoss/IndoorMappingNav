//
//  FloorButton.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct FloorButton: View {
    @State var btnLbl: String = "GF"
    @State private var didTap = false
    
    // TODO: bikin buat yang jumlah konten itu
    @State var contentNum: Int = 0
    
    
    var body: some View {
        Button {
            print("tits")
            didTap.toggle()
        } label: {
            // callout has the same property as floor button except its weight
            Text(btnLbl)
                .font(.system(.callout, weight: .semibold))
        }
        .padding(12)
        .foregroundStyle(didTap ? .white : .secondaryAlt)
        .background(didTap ? .blue600 : .backgroundSecondary)
        .clipShape(.circle)
        .customBadge(5, color: .toilet)
    }
}

#Preview {
    FloorButton()
}
