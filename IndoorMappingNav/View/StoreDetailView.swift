//
//  StoreDetailView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import Foundation
import SwiftUI

struct StoreDetailView: View {
    @State private var viewModel = ViewModel()
    var storeName: String
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.store?.name ?? "Error: No Store Name")
                .font(.system(.title3))
            Text(viewModel.store?.category ?? "Error: No Category")
                .font(.system(.caption))
            Text(viewModel.store?.address ?? "Error: No Address")
                .font(.system(.caption))
            
            ImageCarousel(images: ["Image1", "Image2", "Image3"])
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
        .onAppear() {
            viewModel.getStoreDetail(storeName)
        }
    }
}

#Preview {
    StoreDetailView(storeName: "Test")
}
