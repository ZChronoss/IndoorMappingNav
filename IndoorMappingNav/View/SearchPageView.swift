//
//  SearchPageView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 29/10/24.
//

import SwiftUI

struct SearchPageView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var query = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                ForEach(viewModel.stores) {store in
                    SearchResult(store: store)
                }
            }
        }
        .ignoresSafeArea()
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .task {
            await viewModel.getStores()
        }
        .background(.white)
    }
}

#Preview {
    SearchPageView()
}
