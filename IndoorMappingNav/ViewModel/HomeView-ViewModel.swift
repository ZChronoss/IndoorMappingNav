//
//  HomeView-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 30/10/24.
//

import Foundation
import SwiftUI
import RealityKit

//extension HomeViewComponents {
//@MainActor
class HomeViewModel: ObservableObject {
    private let cloudkitController = CloudKitController()
    /// SEARCH FUNC
    @Published var isSearching: Bool = false
    @Published var selectedDestination: Store?
    
    @Published var storeName: String = ""
    @Published var selectedStore: Store?
    
    @Published var isLoading = false
    
    @Published var isCategorySheetOpen = false
    @Published var categoryDetent: PresentationDetent = .fraction(0.25)
    
    // Baru
    @Published var stores: [Store] = []
    @Published var categoryStoreTarget: [String: [Entity]] = [
        "Toilet": [],
        "Food & Beverage": [],
        "Shopping": [],
        "Service": [],
        "Health & Beauty": [],
        "Entertainment": [],
        "Other": []
    ]
    var entityPositions: [Entity: simd_float3] = [:]
    var entityState: [Entity: Bool] = [:]
    
    @Published var isMoving: Bool = false
    @Published var originalMaterials: [Entity: [RealityKit.Material]] = [:] // Store original materials
    
    @Published var selectedCategory: String = ""
    @Published var previousCategory: String = ""  // Store previous category
    
    var categories: [StoreCategory] = [
        StoreCategory(name: .fnb),
        StoreCategory(name: .shopping),
        StoreCategory(name: .entertainment),
        StoreCategory(name: .toilet),
        StoreCategory(name: .service),
        StoreCategory(name: .hnb),
        StoreCategory(name: .other)
    ]
    
    func updateCategory(_ newCategory: String) {
        previousCategory = selectedCategory  // Store the previous category
        selectedCategory = newCategory        // Update the current category
    }
    
    func getStores() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            guard let stores = try? await cloudkitController.fetchStores() else {
                self.stores = []
                return
            }
            await MainActor.run {
                self.stores = stores
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func getStoreDetail() async {
        isLoading = true
        
        do {
            self.selectedStore = try await cloudkitController.fetchStoreByName(name: storeName)
        } catch {
            print("Error: Data fetching failed (\(error.localizedDescription))")
        }
        
        //        isLoading = false
    }
    
    func isEntitySelectable(_ entity: Entity) -> Bool {
        return !(entity.name.prefix(3) == "pwy" || entity.name == "Based" || entity.name.prefix(3) == "PSP" || entity.name.prefix(6) == "Kosong")
    }
    
    func handleEntitySelectionAndMovement(
        target: Entity,
        entityPositions: inout [Entity: simd_float3],
        entityState: inout [Entity: Bool]
    ) {
        guard isEntitySelectable(target) else { return }
        
        guard !isMoving else { return } // Ignore tap if movement is ongoing
        isMoving = true // Lock the tap gesture
        
        let curTransform = target.transform
        let curTranslation = curTransform.translation
        let moveUpDistance: Float = 0.2 // Distance to move up
        
        if entityPositions[target] == nil {
            entityPositions[target] = curTranslation
            entityState[target] = false
            
            if let modelEntity = target as? ModelEntity,
               let materials = modelEntity.model?.materials {
                originalMaterials[target] = materials
            }
        }
        
        if let isMoved = entityState[target] {
            var moveToLocation = curTransform
            if isMoved {
                moveToLocation.translation = simd_float3(
                    x: curTranslation.x,
                    y: curTranslation.y - moveUpDistance,
                    z: curTranslation.z
                )
                entityState[target] = false
                
                if let originalMaterial = originalMaterials[target],
                   let modelEntity = target as? ModelEntity {
                    modelEntity.model?.materials = originalMaterial
                }
                
                changeEntityColor(target, color: .gray)
                
            } else {
                moveToLocation.translation = simd_float3(
                    x: curTranslation.x,
                    y: curTranslation.y + moveUpDistance,
                    z: curTranslation.z
                )
                entityState[target] = true
                
                var matchFound = false

                for store in stores {
                    if let storeName = store.name?.removeSpecialCharacters(),
                       storeName.contains(target.name.removeSpecialCharacters()) {
                        changeEntityColor(target, color: store.category?.color.asUIColor ?? .gray)
                        matchFound = true
                        break // Exit loop once a match is found
                    }
                }
                // If no match was found, apply the default gray color
                if !matchFound {
                    changeEntityColor(target, color: .gray)
                }
            }
            
            target.move(to: moveToLocation, relativeTo: target.parent, duration: 0.5)
            storeName = target.name
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isMoving = false // Unlock the gesture after movement finishes
            }
        }
    }
    
    func moveDownEntitiesInCategory(_ currentCategory: String) {
        if let previousEntities = categoryStoreTarget[previousCategory] {
            for entity in previousEntities {
                let moveUpDistance: Float = 0.2
                var newTransform = entity.transform
                newTransform.translation.y -= moveUpDistance // Move up by `moveUpDistance`
                entity.move(to: newTransform, relativeTo: entity.parent, duration: 0.5)
                
                applyHighlightColor(to: entity, color: .gray)
            }
        }
        selectedCategory = ""
    }
    
    func moveDownEntitiesInCurrentCategory(_ currentCategory: String) {
        if let previousEntities = categoryStoreTarget[currentCategory] {
            for entity in previousEntities {
                let moveUpDistance: Float = 0.2
                var newTransform = entity.transform
                newTransform.translation.y -= moveUpDistance // Move up by `moveUpDistance`
                entity.move(to: newTransform, relativeTo: entity.parent, duration: 0.5)
                
                applyHighlightColor(to: entity, color: .gray)
            }
        }
    }
    
    func moveEntitiesInCategory(_ newCategory: String, _ categoryColor: UIColor) {
        // Reset entities from the previous category to their original states
        if let previousEntities = categoryStoreTarget[previousCategory] {
            for entity in previousEntities {
                let moveUpDistance: Float = 0.2
                var newTransform = entity.transform
                newTransform.translation.y -= moveUpDistance // Move up by `moveUpDistance`
                entity.move(to: newTransform, relativeTo: entity.parent, duration: 0.5)
                
                applyHighlightColor(to: entity, color: .gray)
            }
        }

        // Move and update materials for entities in the new category
        guard let entities = categoryStoreTarget[newCategory] else { return }
        for entity in entities {
            // Move each entity up by a certain distance, e.g., 0.5 units
            let moveUpDistance: Float = 0.2
            var newTransform = entity.transform
            newTransform.translation.y += moveUpDistance // Move up by `moveUpDistance`
            entity.move(to: newTransform, relativeTo: entity.parent, duration: 0.5)

            // Change entity color to indicate selection
            applyHighlightColor(to: entity, color: categoryColor)
        }

        // Update the selected category to the new one
        selectedCategory = newCategory
    }

    func applyHighlightColor(to entity: Entity, color: UIColor) {
        var material = PhysicallyBasedMaterial()
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color)
        material.metallic = 0.5
        material.roughness = 0.5

        if let modelEntity = entity as? ModelEntity {
            modelEntity.model?.materials = [material]
        }
    }
    
    func changeEntityColor(_ entity: Entity, color: UIColor) {
        var material = PhysicallyBasedMaterial()
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color)
        material.metallic = 0.5
        material.roughness = 0.5
        
        if let modelEntity = entity as? ModelEntity {
            modelEntity.model?.materials = [material]
        }
    }
    
    // Function to categorize entities in the scene
    func categorizeEntitiesInScene(_ scene: Entity) {
        // Iterate over all child entities of the scene
        
        for entity in scene.children {
            
            // Loop through all the stores in stores[]
            for store in stores {
                categorizeEntityByStore(target: entity, store: store)
            }
            // Recursively categorize child entities
            categorizeEntitiesInScene(entity)
        }
    }
    
    func categorizeEntityByStore(target: Entity, store: Store) {
        guard let storeName = store.name else { return }
        
        guard isEntitySelectable(target)
        else { return }
        // Normalize both store name and target name
        let normalizedStoreName = storeName.removeSpecialCharacters()
        let normalizedTargetName = target.name.removeSpecialCharacters()
        
        // Check if the normalized target name is contained within the normalized store name
        guard normalizedStoreName.contains(normalizedTargetName) else {
            //                print("No match found")
            return
        }
        
        // Check the category of the store and categorize accordingly
        guard let storeCategory = store.category?.name.rawValue else {
            categoryStoreTarget["Other"]?.append(target)
            return
        }
        
        switch storeCategory {
            //            case "Toilet":
            //                categoryStoreTarget["Toilet"]?.append(target)
        case "Food & Beverage":
            categoryStoreTarget["Food & Beverage"]?.append(target)
            //            case .shopping:
            //                categoryStoreTarget["Shopping"]?.append(target)
            //            case .service:
            //                categoryStoreTarget["Service"]?.append(target)
        case "Health & Beauty":
            categoryStoreTarget["Health & Beauty"]?.append(target)
            //            case .entertainment:
            //                categoryStoreTarget["Entertainment"]?.append(target)
        default:
            categoryStoreTarget["Other"]?.append(target)
        }
    }
}
//}



//func printEntitiesInScene(_ entity: Entity, indent: String = "") {
////        print("\(indent)Entity: \(entity.name.removeUnderscores())")
//    
//    // Iterate through all children of the entity and print their names
//    for child in entity.children {
//        printEntitiesInScene(child, indent: indent + "    ") // Increase indentation for child entities
//    }
//}
//
//func printCategoryStoreTarget() {
//    for (category, entities) in categoryStoreTarget {
////            print("\(category):")
//        for entity in entities {
////                print("  - \(entity.name)")
//        }
//    }
//}
//
//func printStores() {
//    for store in stores {
////            print(store.name ?? "")
//    }
//}
