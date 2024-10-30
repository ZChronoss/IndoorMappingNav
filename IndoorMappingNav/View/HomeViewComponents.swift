//
//  HomeViewComponents.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 30/10/24.
//

import SwiftUI

struct HomeViewComponents: View {
    @StateObject var vm = ViewModel()
    @State private var selectedCategory: String = "Food & Beverage"
    
    var body: some View {
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
            
            Spacer()  //Push the RealityView to the bottom
        }
    }
}

#Preview {
    HomeViewComponents()
}

