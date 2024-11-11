////
////  HomeView-ViewModel.swift
////  IndoorMappingNav
////
////  Created by Renaldi Antonio on 30/10/24.
////
//
//import Foundation
//import SwiftUI
//import RealityKit
//
////extension HomeViewComponents {
////    @MainActor
//class HomeViewModel: ObservableObject {
//    private let cloudkitController = CloudKitController()
//    /// SEARCH FUNC
//    @Published var isSearching: Bool = false
//    @Published var selectedDestination: Store?
//    
//    @Published var storeName: String = ""
//    @Published var selectedStore: Store?
//    
//    @Published var isLoading = false
//    
//    @Published var isCategorySheetOpen = false
//    @Published var categoryDetent: PresentationDetent = .fraction(0.17)
//    
//    // Baru
//    @Published var stores: [Store] = []
//    @Published var categoryStoreTarget: [String: [Entity]] = [
//        "Toilet": [],
//        "Food & Beverage": [],
//        "Shopping": [],
//        "Service": [],
//        "Health & Beauty": [],
//        "Entertainment": [],
//        "Other": []
//    ]
//    var entityPositions: [Entity: simd_float3] = [:]
//    var entityState: [Entity: Bool] = [:]
//    
//    @Published var isMoving: Bool = false
//    @Published var originalMaterials: [Entity: [RealityKit.Material]] = [:] // Store original materials
//    
//    @Published var selectedCategory: String = ""
//    
//    init() {
//        // Run getStores asynchronously when the view model is initialized
//        Task {
//            await getStores()
//        }
//    }
//    
//    
//    // Ini yang jalan
//    //        private var scene: Entity? // Stores the scene
//    //
//    //        init(scene: Entity?) {
//    //            self.scene = scene
//    //            Task {
//    //                await fetchAndCategorizeStores()
//    //            }
//    //        }
//    //
//    //        private func fetchAndCategorizeStores() async {
//    //            await getStores()
//    //            if let scene = scene {
//    //                categorizeEntitiesInScene(scene)
//    //            }
//    //        }
//    
//    func getStores() async {
//        self.isLoading = true
//        
//        do {
//            guard let stores = try? await cloudkitController.fetchStores() else {
//                self.stores = []
//                return
//            }
//            await MainActor.run {
//                self.stores = stores
//            }
//        }
//        self.isLoading = false
//    }
//    
//    func getStoreDetail() async {
//        isLoading = true
//        
//        do {
//            self.selectedStore = try await cloudkitController.fetchStoreByName(name: storeName)
//        } catch {
//            print("Error: Data fetching failed (\(error.localizedDescription))")
//        }
//        
//        //        isLoading = false
//    }
//    
//    func isEntitySelectable(_ entity: Entity) -> Bool {
//        return !(entity.name.prefix(3) == "pwy" || entity.name == "Based" || entity.name.prefix(3) == "PSP" || entity.name.prefix(6) == "Kosong")
//    }
//    
//    func handleEntitySelectionAndMovement(
//        target: Entity,
//        entityPositions: inout [Entity: simd_float3],
//        entityState: inout [Entity: Bool]
//    ) {
//        guard isEntitySelectable(target) else { return }
//        
//        guard !isMoving else { return } // Ignore tap if movement is ongoing
//        isMoving = true // Lock the tap gesture
//        
//        let curTransform = target.transform
//        let curTranslation = curTransform.translation
//        let moveUpDistance: Float = 0.5 // Distance to move up
//        
//        if entityPositions[target] == nil {
//            entityPositions[target] = curTranslation
//            entityState[target] = false
//            
//            if let modelEntity = target as? ModelEntity,
//               let materials = modelEntity.model?.materials {
//                originalMaterials[target] = materials
//            }
//        }
//        
//        if let isMoved = entityState[target] {
//            var moveToLocation = curTransform
//            if isMoved {
//                moveToLocation.translation = simd_float3(
//                    x: curTranslation.x,
//                    y: curTranslation.y - moveUpDistance,
//                    z: curTranslation.z
//                )
//                entityState[target] = false
//                
//                if let originalMaterial = originalMaterials[target],
//                   let modelEntity = target as? ModelEntity {
//                    modelEntity.model?.materials = originalMaterial
//                }
//                
//                changeEntityColor(target, color: .gray)
//                
//            } else {
//                moveToLocation.translation = simd_float3(
//                    x: curTranslation.x,
//                    y: curTranslation.y + moveUpDistance,
//                    z: curTranslation.z
//                )
//                entityState[target] = true
//                
//                changeEntityColor(target, color: .blue)
//            }
//            
//            target.move(to: moveToLocation, relativeTo: target.parent, duration: 0.5)
//            storeName = target.name
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.isMoving = false // Unlock the gesture after movement finishes
//            }
//        }
//    }
//    
//    func moveEntitiesInCategory(_ category: String) {
//        // Reset entities from the previous category to their original states
//        if let previousEntities = categoryStoreTarget[selectedCategory] {
//            for entity in previousEntities {
//                if let originalPosition = entityPositions[entity],
//                   let originalMaterial = originalMaterials[entity],
//                   let modelEntity = entity as? ModelEntity {
//                    entity.transform.translation = originalPosition // Restore position
//                    modelEntity.model?.materials = originalMaterial // Restore material
//                }
//            }
//        }
//
//        // Move and update materials for entities in the new category
//        guard let entities = categoryStoreTarget[category] else { return }
//        for entity in entities {
//            // Move each entity up by a certain distance, e.g., 0.5 units
//            let moveUpDistance: Float = 0.5
//            var newTransform = entity.transform
//            newTransform.translation.y += moveUpDistance // Move up by `moveUpDistance`
//            entity.transform = newTransform
//
//            // Change entity color
//            applyHighlightColor(to: entity, color: .blue)
//        }
//
//        // Update the selected category
//        selectedCategory = category
//    }
//
//    func applyHighlightColor(to entity: Entity, color: UIColor) {
//        var material = PhysicallyBasedMaterial()
//        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color)
//        material.metallic = 0.5
//        material.roughness = 0.5
//
//        if let modelEntity = entity as? ModelEntity {
//            modelEntity.model?.materials = [material]
//        }
//    }
//    
//    func changeEntityColor(_ entity: Entity, color: UIColor) {
//        var material = PhysicallyBasedMaterial()
//        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color)
//        material.metallic = 0.5
//        material.roughness = 0.5
//        
//        if let modelEntity = entity as? ModelEntity {
//            modelEntity.model?.materials = [material]
//        }
//    }
//    
//    func printEntitiesInScene(_ entity: Entity, indent: String = "") {
//        print("\(indent)Entity: \(entity.name.removeUnderscores())")
//        
//        // Iterate through all children of the entity and print their names
//        for child in entity.children {
//            printEntitiesInScene(child, indent: indent + "    ") // Increase indentation for child entities
//        }
//    }
//    
//    func printCategoryStoreTarget() {
//        for (category, entities) in categoryStoreTarget {
//            print("\(category):")
//            for entity in entities {
//                print("  - \(entity.name)")
//            }
//        }
//    }
//    
//    func printStores() {
//        for store in stores {
//            print(store.name ?? "")
//        }
//    }
//    
//    // Function to categorize entities in the scene
//    func categorizeEntitiesInScene(_ scene: Entity) {
//        // Iterate over all child entities of the scene
//        
//        for entity in scene.children {
//            
//            // Loop through all the stores in stores[]
//            for store in stores {
//                categorizeEntityByStore(target: entity, store: store)
//            }
//            // Recursively categorize child entities
//            categorizeEntitiesInScene(entity)
//        }
//    }
//    
//    func categorizeEntityByStore(target: Entity, store: Store) {
//        guard let storeName = store.name else { return }
//        
//        guard isEntitySelectable(target)
//        else { return }
//        // Normalize both store name and target name
//        let normalizedStoreName = storeName.removeSpecialCharacters()
//        let normalizedTargetName = target.name.removeSpecialCharacters()
//        
//        // Debugging: print normalized values to verify
//        print("Normalized Store Name:", normalizedStoreName)
//        print("Normalized Target Name:", normalizedTargetName)
//        
//        // Check if the normalized target name is contained within the normalized store name
//        guard normalizedStoreName.contains(normalizedTargetName) else {
//            //                print("No match found")
//            return
//        }
//        
//        print(store.category?.name.rawValue ?? "No category")
//        
//        // Check the category of the store and categorize accordingly
//        guard let storeCategory = store.category?.name.rawValue else {
//            categoryStoreTarget["Other"]?.append(target)
//            return
//        }
//        
//        // Logic to categorize based on storeCategory
//        print("Category: \(storeCategory)")
//        
//        switch storeCategory {
//            //            case "Toilet":
//            //                categoryStoreTarget["Toilet"]?.append(target)
//        case "Food & Beverage":
//            categoryStoreTarget["Food & Beverage"]?.append(target)
//            //            case .shopping:
//            //                categoryStoreTarget["Shopping"]?.append(target)
//            //            case .service:
//            //                categoryStoreTarget["Service"]?.append(target)
//        case "Health & Beauty":
//            categoryStoreTarget["Health & Beauty"]?.append(target)
//            //            case .entertainment:
//            //                categoryStoreTarget["Entertainment"]?.append(target)
//        default:
//            categoryStoreTarget["Other"]?.append(target)
//        }
//    }
//}
////}


//
//  HomeView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 11/10/24.
//

//import SwiftUI
//import RealityKit
//import MallMap
//
//struct HomeView: View {
//    @StateObject var vm = HomeViewModel()
//    
////    @StateObject private var vm: HomeViewModel
////
////    init() {
////        _vm = StateObject(wrappedValue: HomeViewModel(scene: nil))
////    }
//    
//    
//    @StateObject var pathfinder = PathfindingService.shared
//    @StateObject var pathfinder2D = PathfindingService2D.shared
//    
//    @State private var entityPositions: [Entity: simd_float3] = [:] // Store only the original position
//    @State private var entityState: [Entity: Bool] = [:]
//    
//    @State var scale: Float = 0.2
////    @State private var isMoving: Bool = false
//    @State private var originalMaterials: [Entity: [RealityKit.Material]] = [:] // Store original materials
//    
//    // ini apus aja kah?
////    @State private var selectedCategory: String = "Food & Beverage"
////    // Setelah gua tambahin ini, kenapa jadi beda
////    @State private var isCategorySheetOpen = false
////    @State var categoryDetent: PresentationDetent = .fraction(0.17)
//    
//    @State private var scene: Entity? = nil
//    @State private var pathEntities: [Entity] = []
//    @State var is2DMode = false
//    
//    var body: some View {
//        NavigationStack{
//            ZStack {
//                // Main RealityView content
//                RealityView { content in
//                    if let loadedScene = try? await Entity(named: "Test2", in: mallMapBundle) {
//                        scene = loadedScene
//                        scene?.setScale([scale, scale, scale], relativeTo: nil)
//                        content.add(scene!)
//                        
//                        // PathFinding
////                        pathfinder.setupPath(loadedScene: scene!)
////                        pathfinder.startNavigation(start: "Huawei", end: "Lift")
//                        
//                        // Print all entities in the scene
////                        vm.printEntitiesInScene(scene!)
//
//                        // Call categorizeEntityByStore function to categorize all entities in the scene
//                        
//        
//                        // Print categoryStoreTarget contents
////                        vm.printCategoryStoreTarget()
//                    }
//                }
//                .realityViewCameraControls(is2DMode ? .pan : .orbit)
//                .gesture(
//                    SpatialTapGesture()
//                        .targetedToAnyEntity()
//                        .onEnded({ target in
//                            vm.handleEntitySelectionAndMovement(
//                                target: target.entity,
//                                entityPositions: &entityPositions,
//                                entityState: &entityState
//                            )
//                        })
//                )
//                
//                // Overlay: Location title, search bar, and category buttons
//                if is2DMode == false {
//                    HomeViewComponents(selectedCategory: $vm.selectedCategory)
//                        .environmentObject(vm)
//                }
//                else {
//                    NavigateView()
//                }
//                VStack {
//                    Spacer()
//                    
//                    // Debugging
//                    Button("Clicked") {
//                        vm.categorizeEntitiesInScene(scene!)
//                        vm.printCategoryStoreTarget()
//                    }
//                    
//                    
//                    Button("2D Mode") {
//                        // 3D to 2D path conversion (flatten Y-axis)
//                        guard let scene = scene else { return }
//                        scene.setScale([2,2,2], relativeTo: nil)
//                        let path = pathfinder.interEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
//                        guard let camera = pathfinder.cameraEntity else { return }
//                        pathfinder2D.setup2DNavigation(path: path, scene: scene, camera: camera)
//                        is2DMode = true
//                    }
//                    .padding(.bottom)
//                }
//            }
//            .padding(.top, 56)
//            .ignoresSafeArea()
//            .environmentObject(pathfinder2D)
//            .environmentObject(pathfinder)
//        }
//    }
//}
//
//#Preview {
//    HomeView()
//}

////
////  HomeViewComponents.swift
////  IndoorMappingNav
////
////  Created by Leonardo Marhan on 30/10/24.
////
//
//import SwiftUI
//
//struct HomeViewComponents: View {
//    @EnvironmentObject var vm: HomeViewModel
//    
//    // Ini yang jalan
////    @StateObject private var vm: HomeViewModel
////
////    init() {
////        _vm = StateObject(wrappedValue: HomeViewModel(scene: nil))
////    }
//    
//    
//    @State var isSheetOpen = false
////    @State private var selectedCategory: String = "Food & Beverage"
//    
//    @Binding var selectedCategory: String  // Add this
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                ZStack(alignment: .top) {
//                    // White background rectangle
//                    CustomCornerShape(radius: 20, corners: [.bottomLeft, .bottomRight])
//                        .fill(Color(UIColor.systemBackground))
//                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
//                        .frame(height: 95) // Adjust this value to control how far down the rectangle extends
//                    
//                    VStack(spacing: 0) {
//                        HStack {
//                            Text("Summarecon Mall Serpong")
//                                .font(.system(size: 22, weight: .bold))
//                                .foregroundColor(.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(.black)
//                        }
//                        .padding(.top, 20)
//                        .padding(.horizontal, 20)
//                        .padding(.bottom, 16)
//                        
//                        SearchBar(searchText: .constant(""), image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
//                            .padding(.horizontal, 20)
//                            .disabled(true)
//                            .onTapGesture {
//                                vm.selectedDestination = Store()
//                                vm.isSearching = true
//                                isSheetOpen = false
//                            }
//                            .navigationDestination(isPresented: $vm.isSearching) {
//                                SearchPageView(destStore: vm.selectedDestination ?? Store()) { store in
//                                    vm.selectedStore = store
//                                    vm.storeName = store.name ?? ""
//                                    isSheetOpen = true
//                                }
//                            }
//                    }
//                }
//                .sheet(isPresented: $isSheetOpen) {
//                    StoreDetailView(store: vm.selectedStore ?? Store()) { store in
//                        vm.selectedDestination = store
//                        vm.isSearching = true
//                        isSheetOpen = false
//                    }
//                    .presentationDetents([.fraction(0.5)])
//                    .presentationBackgroundInteraction(.enabled)
//                }
//                .sheet(isPresented: $vm.isCategorySheetOpen) {
//                    NavigationStack {
//                        CategorySheet(categoryName: selectedCategory, categoryDetent: $vm.categoryDetent)
//                    }
//                }
//                
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        CategoryButton(categoryName: "Food & Beverage", categoryIcon: "fork.knife", categoryColor: .red, isSelected: selectedCategory == "Food & Beverage") {
//                            selectedCategory = "Food & Beverage"
//                            vm.isCategorySheetOpen = true
//                            vm.moveEntitiesInCategory("Food & Beverage")
//                        }
//                        CategoryButton(categoryName: "Shopping", categoryIcon: "cart", categoryColor: .green, isSelected: selectedCategory == "Shopping") {
//                            selectedCategory = "Shopping"
//                            vm.isCategorySheetOpen = true
//                            vm.moveEntitiesInCategory("Shopping")
//                        }
//                        CategoryButton(categoryName: "Entertainment", categoryIcon: "gamecontroller", categoryColor: .purple, isSelected: selectedCategory == "Entertainment") {
//                            selectedCategory = "Entertainment"
//                            vm.isCategorySheetOpen = true
//                            vm.moveEntitiesInCategory("Entertainment")
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.top, 16)
//                
//                Spacer()  //Push the RealityView to the bottom
//            }
//        }
//        
//    }
//}
//
////#Preview {
////    HomeViewComponents()
////}
//
