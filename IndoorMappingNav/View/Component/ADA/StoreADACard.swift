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
        HStack {
            // Icon
            if let data = store.logo, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.trailing, 10)
                    .padding(.leading, 21)
                    .padding(.vertical, 12)
            }  else {
                // Placeholder view if the image is not available
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.trailing, 15)
                    .padding(.leading, 21)
                    .padding(.vertical, 12)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 8
                        )
                    )
            }
            
            // Information
            VStack (alignment: .leading, spacing: 4) {
                Spacer(minLength: 0)
                
                Text(store.name ?? "Unknown Store")
                    .font(.callout)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                    .lineLimit(1) // Limit to a single line
                    .truncationMode(.tail)
                    .padding(.bottom, 2)
                
                Text(store.description ?? "No Description")
                    .font(.caption)
                    .foregroundColor(Color("SecondaryColor"))

                
                Spacer()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
    StoreADACard(store: Store(), color: .black)
}
