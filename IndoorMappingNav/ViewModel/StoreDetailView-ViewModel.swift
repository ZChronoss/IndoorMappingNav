//
//  StoreViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 07/10/24.
//

import Foundation

extension StoreDetailView {
    
    @Observable
    class ViewModel {
        var store: Store?
        
        func getStoreDetail(_ name: String) {
            
            //Need to add logic with the database we use
            self.store = Store(name: name, category: "Fashion & Lifestyle", address: "Blok O, G South Floor", images: ["Image1", "Image2", "Image3"])
        }
    }
}
