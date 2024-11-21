//
//  StoreADACard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 20/11/24.
//

import SwiftUI

struct StoreADACard: View {
    var store: Store
    var color: Color
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            if let imageData = store.images?.first,
               let validData = imageData,
               let uiImage = UIImage(data: validData) {
                Image(uiImage: uiImage)
                    .frame(width: 159, height: 102)
//                    .resizable()
//                    .scaledToFit()
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 8
                        )
                    )
                    .contentShape(Path(CGRect(x: 0, y: 0, width: 159, height: 102)))
            } else {
                // Placeholder view if the image is not available
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 100)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 8
                        )
                    )
            }
//            Image(images)

            
            VStack(alignment: .leading) {
                Text(store.name ?? "Unknown Store")
                    .font(.callout)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                    .lineLimit(1) // Limit to a single line
                    .truncationMode(.tail)

//                Text(store.category?.name.rawValue ?? "Unknown Category")
//                    .font(.caption)
//                    .foregroundColor(Color("SecondaryColor"))
            }

            Text(store.floor ?? "Unknown Floor")
                .font(.caption)
                .foregroundColor(Color("SecondaryColor"))
            
        }
        .padding(8)
        .background(Color("CategoryCard"))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.19), radius: 5)
    }
}

//#Preview {
//    let store = Store()
//    store.name = "Sample Store"
//    store.floor = "1st Floor"
//    store.category = StoreCategory(name: .fnb)
//    return StoreCard(store: store, color: .gray)
//}

#Preview {
    HomeView()
}