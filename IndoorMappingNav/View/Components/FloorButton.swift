//
//  FloorButton.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct FloorButton: View {
    @State var btnLbl: String?
    @State private var didTap = false
    
    // TODO: bikin buat yang jumlah konten itu
    
    var body: some View {
        Button {
            print("tits")
            didTap.toggle()
        } label: {
            // callout has the same property as floor button except its weight
            Text("GF")
                .font(.system(.callout, weight: .semibold))
                .padding(10)
                .foregroundStyle(didTap ? .white : .secondaryAlt)
                .background(didTap ? .blue600 : .backgroundSecondary)
                .clipShape(.circle)
        }
    }
}

#Preview {
    FloorButton()
}
