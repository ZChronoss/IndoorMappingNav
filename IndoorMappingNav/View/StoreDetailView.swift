//
//  StoreDetailView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import Foundation
import SwiftUI

struct StoreDetailView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 3) {
                // TITLE
                Text(viewModel.store.name ?? "Hai")
                    .font(.system(.title3))
                
                // CATEGORY
                HStack(spacing: 2) {
                    Image(viewModel.store.category?.image ?? "")
                        .resizable()
                        .frame(width: 13, height: 13)
                    
                    Text(viewModel.store.category?.name.rawValue ?? "Error: No Category")
                        .font(.system(.caption))
                        .bold()
                        .foregroundStyle(viewModel.store.category?.color ?? .black)
                }
                
                // ADDRESS
                Text((viewModel.store.address ?? "") + ", " + (viewModel.store.floor ?? "Error: No Address"))
                    .font(.system(.caption))
                    .foregroundStyle(.secondary)
            }
            
            // IMAGE CAROUSEL
            if let images = viewModel.store.images {
                ImageCarousel(images: images)
            }
            
            
            
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
        .redacted(
            reason: viewModel.isLoading ? .placeholder : []
        )
        .refreshable {
//            await viewModel.getStores()
        }
        .task {
//            await viewModel.getStores()
            await viewModel.getStoreDetail("A&W")
        }
    }
}

#Preview {
    StoreDetailView()
}
