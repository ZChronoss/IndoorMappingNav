//
//  HomeView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 11/10/24.
//

import SwiftUI
import RealityKit
import GameplayKit
import MallMap

struct HomeView: View {
    @StateObject var vm = ViewModel()
    
    @StateObject var pathfinder = PathfindingService()
    @StateObject var pathfinder2D = PathfindingService2D()
    
    @State private var entityPositions: [Entity: simd_float3] = [:] // Store only the original position
    @State private var entityState: [Entity: Bool] = [:]
    @State var isSheetOpen = false
    
    @State var scale: Float = 0.2
    @State private var isMoving: Bool = false
    
    @State private var selectedCategory: String = "Food & Beverage"
    
    // Setelah gua tambahin ini, kenapa jadi beda
    @State private var isCategorySheetOpen = false
    @State var categoryDetent: PresentationDetent = .fraction(0.17)
    
    @State private var scene: Entity? = nil
    @State private var pathEntities: [Entity] = []
    
    @State var is2DMode = false
    
    var body: some View {
        ZStack {
            // Main RealityView content
            RealityView { content in
                if let loadedScene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    scene = loadedScene
                    content.add(scene!)
                    scene?.setScale([scale, scale, scale], relativeTo: nil)
                    pathfinder.setupPath(loadedScene: scene!)
                    
                    pathfinder.startNavigation(start: "Huawei", end: "Lift")
                }
            }
            .realityViewCameraControls(is2DMode ? .pan : .orbit)
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded({ target in
                        guard !isMoving else { return } // Ignore tap if movement is ongoing
                        isMoving = true // Lock the tap gesture
                        let curTransform = target.entity.transform
                        let curTranslation = curTransform.translation
                        let moveUpDistance: Float = 0.5 // 1000cm = 10 meters
                        
                        // Check if the entity was clicked for the first time
                        if entityPositions[target.entity] == nil {
                            // Store the original position when clicked for the first time
                            entityPositions[target.entity] = curTranslation
                            entityState[target.entity] = false // Initially at original position
                        }
                        
                        if let originalPosition = entityPositions[target.entity], let
                            isMoved = entityState[target.entity] {
                            
                            var moveToLocation = curTransform
                            
                            if isMoved {
                                moveToLocation.translation = simd_float3(x: curTranslation.x,
                                                                         y: curTranslation.y - moveUpDistance,
                                                                         z: curTranslation.z)
                                entityState[target.entity] = false
                            } else {
                                moveToLocation.translation = simd_float3(x: curTranslation.x,
                                                                         y: curTranslation.y + moveUpDistance,
                                                                         z: curTranslation.z)
                                entityState[target.entity] = true
                            }
                            
                            // Move the entity up by 1000cm (10 meters)
                            target.entity.move(to: moveToLocation, relativeTo: target.entity.parent, duration: 0.5)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isMoving = false // Unlock the gesture after movement finishes
                                selectedStore = target.entity.name
                            }
                        }
                    })
            )
            

            // Overlay: Location title, search bar, and category buttons
            

            VStack {
                ZStack(alignment: .top) {
                    // White background rectangle
                    CustomCornerShape(radius: 20, corners: [.bottomLeft, .bottomRight])
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                        .frame(height: 95) // Adjust this value to control how far down the rectangle extends

                    VStack(spacing: 0) {
                        HStack {
                            Text("Summarecon Mall Serpong")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                        SearchBarWithCancel(searchText: $vm.searchText)
                            .padding(.horizontal, 20)
                            .disabled(true)
                            .onTapGesture {
                                SearchPageView()
                            }
                    }
                }


                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryButton(categoryName: "Food & Beverage", categoryIcon: "fork.knife", categoryColor: .red, isSelected: selectedCategory == "Food & Beverage") {
                            selectedCategory = "Food & Beverage"
                        }
                        CategoryButton(categoryName: "Shopping", categoryIcon: "cart", categoryColor: .green, isSelected: selectedCategory == "Shopping") {
                            selectedCategory = "Shopping"
                        }
                        CategoryButton(categoryName: "Entertainment", categoryIcon: "gamecontroller", categoryColor: .purple, isSelected: selectedCategory == "Entertainment") {
                            selectedCategory = "Entertainment"
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                
                Spacer() // Push the RealityView to the bottom
            }
        }
        .onChange(of: selectedStore, { oldValue, newValue in
            isSheetOpen.toggle()
        })
        .sheet(isPresented: $isSheetOpen) {
            StoreDetailView()
                .presentationDetents([.fraction(0.5)])
                .presentationBackgroundInteraction(.enabled)
        }
        .padding(.top, 56)
        .ignoresSafeArea()
        Button("2D Mode") {
            // 3D to 2D path conversion (flatten Y-axis)
            guard let scene = scene else { return }
            scene.setScale([2,2,2], relativeTo: nil)
            let path = pathfinder.interEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
            guard let camera = pathfinder.cameraEntity else { return }
            pathfinder2D.setup2DNavigation(path: path, scene: scene, camera: camera)
            is2DMode = true
        }
        // Navigation buttons
        HStack {
            Button("Previous") {
                pathfinder2D.moveToPreviousNode()
            }
            Button("Next") {
                pathfinder2D.moveToNextNode()
            }
        }
        .padding()
    }
}

struct CustomCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#Preview {
    HomeView()
}
