//
//  Category.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 22/10/24.
//
import Foundation
import SwiftUI

enum CategoryType: String{
    case toilet = "Toilet"
    case fnb = "Food & Beverage"
    case shopping = "Shopping"
    case service = "Service"
    case hnb = "Health & Beauty"
    case entertainment = "Entertainment"
    case other = "Other"
}

class Category {
    var name: CategoryType
    var image: String
    var color: Color
    var subcategory: [SubCategory]?
    
    init(name: CategoryType, image: String, subcategory: [SubCategory]?) {
        self.name = name
        self.image = image
        self.subcategory = subcategory
        
        switch name {
        case .toilet:
            self.color = .toilet
            break
        case .fnb:
            self.color = .fnB
            break
        case .shopping:
            self.color = .shop
            break
        case .service:
            self.color = .service
            break
        case .hnb:
            self.color = .hnB
            break
        case .entertainment:
            self.color = .entertainment
            break
        case .other:
            self.color = .other
            break
        }
    }
}
