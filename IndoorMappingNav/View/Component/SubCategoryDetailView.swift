//
//  SubCategoryDetailView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 14/10/24.
//

import Foundation
import SwiftUI

struct SubCategoryDetailView: View {
    var categoryName: String
    var subCategories: [SubCategory]
    @Binding var categoryDetent: PresentationDetent // Add a binding for categoryDetent
    
    @Environment(\.dismiss) private var dismiss  // Dismiss environment for navigating back

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("")
            }
            .padding(.top, 10)
            HStack {
                Button(action: {
                    categoryDetent = .fraction(0.75)
                    dismiss() // Navigate back
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
//                            .font(.system(size: 16, weight: .bold))
                            .resizable()
                            .frame(width: 10, height: 16)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 11)
                        
                        Text("\(categoryName) Categories")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.textIcon)
                    }
                    .foregroundColor(.textIcon) // Customize the color of the back button as desired
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                    ForEach(subCategories, id: \.self) { subCategory in
                        VStack {
                            Image(subCategory.imageName) // Use computed property for image name
                                .resizable()
                                .scaledToFill() // Maintain aspect ratio while filling the space
                                .frame(width: 115, height: 115)
                                .clipped()
                                .cornerRadius(12)
                                .padding(.bottom, 8)

                            Text(subCategory.rawValue) // Use rawValue for display name
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true) // Hide default navigation bar
//        .navigationTitle(categoryName)
        .presentationDetents([categoryDetent])
    }
}

#Preview {
    @State var categoryDetent: PresentationDetent = .fraction(0.75)
    
    SubCategoryDetailView(
        categoryName: "Food & Beverages",
        subCategories: [.bakery, .rice, .fastFood, .indonesian, .japanese], // Use enum cases directly
        categoryDetent: $categoryDetent // Pass the binding here
    )
}
