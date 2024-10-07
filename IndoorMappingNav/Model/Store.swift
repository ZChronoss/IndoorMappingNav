//
//  Store.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 07/10/24.
//

import Foundation

class Store: Identifiable {
    var id: UUID { return UUID()}
    var name: String
    var category: String
    var address: String
    var images: [String]
    
    init(name: String, category: String, address: String, images: [String]) {
        self.name = name
        self.category = category
        self.address = address
        self.images = images
    }
}
