//
//  StoreDetailView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import Foundation
import SwiftUI

struct StoreDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ViewModel()
    var store: Store
    
    var showRoute: (_ store: Store) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 3) {
                    // TITLE
                    Text(viewModel.store.name ?? "Error: No Store Name")
                        .font(.system(.title3))
                    
                    // CATEGORY
                    HStack(spacing: 2) {
                        Image(viewModel.store.category?.image ?? "")
                            .resizable()
                            .renderingMode(.template) 
                            .frame(width: 13, height: 13)
                            .foregroundStyle(viewModel.store.category?.color ?? .other)
                            .tint(viewModel.store.category?.color ?? .other)
                        
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
                        .ignoresSafeArea()
                }
                
                
                
                VStack(alignment: .center) {
                    Button {
                        showRoute(viewModel.store)
                        dismiss()
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
            .onAppear(perform: {
                viewModel.store = store
//                Task {
//                    viewModel.storeName = storeName
//                    await viewModel.getStoreDetail()
//                }
            })
            .redacted(
                reason: viewModel.isLoading ? .placeholder : []
            )
        }
    }
}

#Preview {
//        StoreDetailView()
    HomeView()
}

