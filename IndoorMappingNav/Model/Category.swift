//
//  Category.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 22/10/24.
//
import Foundation
import SwiftUI

enum CategoryType: String{
    case toilet = "Toilet" // 1
    case fnb = "Food & Beverage" // 2
    case shopping = "Shopping" // 3
    case service = "Service" // 4
    case hnb = "Health & Beauty" // 5
    case entertainment = "Entertainment" // 6
    case other = "Other" // 7
}

class StoreCategory {
    var name: CategoryType
    var image: String?
    var color: Color
    var subcategory: [SubCategory]?
    
    init(name: CategoryType, subcategory: [SubCategory]? = nil) {
        self.name = name
        self.subcategory = subcategory
        
        switch name {
        case .toilet:
            self.color = .toilet
            self.image = "toilet2"
            break
        case .fnb:
            self.color = .fnB
            self.image = "foodAndBev"
            break
        case .shopping:
            self.color = .shop
            self.image = "shop"
            break
        case .service:
            self.color = .service
            self.image = "service"
            break
        case .hnb:
            self.color = .hnB
            self.image = "healthAndBeauty"
            break
        case .entertainment:
            self.color = .entertainment
            self.image = "entertainment"
            break
        case .other:
            self.color = .other
            self.image = "other"
            break
        }
    }
    
    func getSubCategories() -> [SubCategory] {
        switch name {
        case .fnb:
            return [
                .bakery, .rice, .fastFood, .indonesian, .japanese, .western, .beverage, .coffee
            ]
        case .shopping:
            return [
                .fashion, .bagnShoes, .electronic, .sport, .momnKid, .supermarket, .home
            ]
        case .hnb:
            return [
                .selfCare, .accessories, .makeup, .perfume, .salon, .clinic, .wellness, .others
            ]
        default:
            return []
        }
    }
}
