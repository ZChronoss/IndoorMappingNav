//
//  SubCategory.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import Foundation

enum SubCategory: String {
    // FNB
    case bakery = "Bakery"
    case rice = "Rice"
    case fastFood = "Fast Food"
    case indonesian = "Indonesian"
    case japanese = "Japanese"
    case western = "Western"
    case beverage = "Beverage"
    case coffee = "Coffee"
    case dessert = "Dessert"
    
    // Shop
    case fashion = "Fashion"
    case bagnShoes = "Bag & Shoes"
    case electronic = "Electronic"
    case sport = "Sport"
    case momnKid = "Mom & Kids"
    case supermarket = "Supermarket"
    case home = "Home"
    
    // Health & Beauty
    case selfCare = "Self-Care"
    case accessories = "Accessories"
    case makeup = "Makeup"
    case perfume = "Perfume"
    case salon = "Salon"
    case clinic = "Clinic"
    case wellness = "Wellness"
    case others = "Others"
    
}

extension SubCategory {
    var imageName: String {
        switch self {
        case .bakery:
            return "bakeryImage" // Replace with the actual image asset name
        case .rice:
            return "riceImage" // Replace with the actual image asset name
        case .fastFood:
            return "fastFoodImage" // Replace with the actual image asset name
        case .indonesian:
            return "indonesianImage" // Replace with the actual image asset name
        case .japanese:
            return "japaneseImage" // Replace with the actual image asset name
        case .western:
            return "westernImage" // Replace with the actual image asset name
        case .beverage:
            return "beverageImage" // Replace with the actual image asset name
        case .coffee:
            return "coffeeImage" // Replace with the actual image asset name
        case .dessert:
            return "dessertImage"
        case .fashion:
            return "fashionImage" // Add as needed
        case .bagnShoes:
            return "bagShoesImage" // Add as needed
        case .electronic:
            return "electronicImage" // Add as needed
        case .sport:
            return "sportImage" // Add as needed
        case .momnKid:
            return "momKidsImage" // Add as needed
        case .supermarket:
            return "supermarketImage" // Add as needed
        case .home:
            return "homeImage" // Add as needed
        case .selfCare:
            return "selfCareImage" // Add as needed
        case .accessories:
            return "accessoriesImage" // Add as needed
        case .makeup:
            return "makeupImage" // Add as needed
        case .perfume:
            return "perfumeImage" // Add as needed
        case .salon:
            return "salonImage" // Add as needed
        case .clinic:
            return "clinicImage" // Add as needed
        case .wellness:
            return "wellnessImage" // Add as needed
        case .others:
            return "othersImage" // Add as needed
        }
    }
}
