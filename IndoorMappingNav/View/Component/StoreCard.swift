//
//  CategoryStoreCard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 17/10/24.
//

import SwiftUI

struct StoreCard: View {
    var store: Store
    var store: Store
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            if let imageData = store.images?.first,
               let validData = imageData,
               let uiImage = UIImage(data: validData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 8
                        )
                    )
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
                Text(store.name ?? "Unknown Store")
                    .font(.callout)
                    .fontWeight(.bold)

                Text(store.category?.name.rawValue ?? "Unknown Category")
                    .font(.caption)
            }

            Text(store.floor ?? "Unknown Floor")
            Text(store.floor ?? "Unknown Floor")
                .font(.caption)
            
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.19), radius: 5)
    }
}

struct RoundedCornersShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    let store = Store()
    store.name = "Sample Store"
    store.floor = "1st Floor"
    store.category = StoreCategory(name: .fnb)
    return StoreCard(store: store)
    let store = Store()
    store.name = "Sample Store"
    store.floor = "1st Floor"
    store.category = StoreCategory(name: .fnb)
    return StoreCard(store: store)
}
