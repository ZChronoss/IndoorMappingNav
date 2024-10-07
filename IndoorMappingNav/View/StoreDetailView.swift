//
//  StoreDetailView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import Foundation
import SwiftUI

struct StoreDetailView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ini Nama Toko")
                .font(.system(.title3))
            Text("Ini Kategori Toko")
                .font(.system(.caption))
            Text("Ini alamat toko")
                .font(.system(.caption))
            
            AutoScroller(images: ["Image1", "Image2", "Image3"])
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Button {
                    
                } label: {
                    Text("View Route")
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 20)
        }
        .safeAreaPadding(.horizontal, 16)
    }
}

#Preview {
    StoreDetailView()
}
