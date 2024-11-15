//
//  HomeView-ViewModelTests.swift
//  IndoorMappingNavTests
//
//  Created by Michael Varian Kostaman on 14/11/24.
//

import XCTest
import RealityKit
@testable import IndoorMappingNav

final class HomeView_ViewModelTests: XCTestCase {
    
    func testSuccessfulUpdateCategory() {
        // Given (Arrange)
        let newCategory = "Food & Beverages"
        let vm = HomeViewModel()
        
        vm.selectedCategory = "Entertainment"
        let previousCategory = vm.selectedCategory
        
        // When (Act)
        vm.updateCategory(newCategory)
        
        // Then (Assert)
        XCTAssertEqual(vm.selectedCategory, newCategory)
    }

//    func testSuccessfulMoveEntitiesInCategory() {
//        // Given
//        let vm = HomeViewModel()
//        let categoryColor = UIColor.red
//        let newCategory = "Food & Beverages"
//        
//        let entity1 = Entity()
//        let entity2 = Entity()
//        vm.categoryStoreTarget[newCategory] = [entity1, entity2]
//        
//        // When
//        vm.moveEntitiesInCategory(newCategory, categoryColor)
//        
//        // Then
//        XCTAssertEqual(vm.selectedCategory, newCategory)
//        XCTAssertEqual(entity1.transform.translation.y, 0.2)
//        XCTAssertEqual(entity2.transform.translation.y, 0.2)
//    }
}
