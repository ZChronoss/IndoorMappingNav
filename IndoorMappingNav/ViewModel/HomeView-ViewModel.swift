//
//  HomeView-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 30/10/24.
//

import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        /// SEARCH FUNC
        @Published var searchText: String = ""
    }
}
