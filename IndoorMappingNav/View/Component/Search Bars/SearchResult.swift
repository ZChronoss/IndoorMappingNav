//
//  SearchResult.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 18/10/24.
//

import SwiftUI

struct SearchResult: View {
    private(set) var store: Store?
    
    var body: some View {
        HStack {
            ZStack(alignment: .center){
                Circle()
                    .foregroundStyle(Color("CategoryCard"))
                    .clipShape(Circle())
                    .frame(width: 47, height: 47)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 4, x: 0, y: 0)
                
                Image(systemName: store?.category?.image ?? "ellipsis")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 23, height: 23)
                    .foregroundStyle(store?.category?.color ?? .other)
                    .padding(10)
                    .tint(store?.category?.color ?? .other)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 8, x: 0, y: 0)
            }
            
            VStack(alignment: .leading) {
                Text(store?.name ?? "Error: No Store Name")
                    .font(.system(.headline))
                    .foregroundColor(Color("TextIcon"))
                
//                Text("Between Nike and Adidas")
//                    .font(.system(.caption, weight: .regular))
//                    .foregroundStyle(Color("SecondaryColor"))
            }
            
            Spacer()
            
            Text(FloorAbbreviation.getFloorAbbreviation(floor: store?.floor ?? "Basement"))
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(Color("SecondaryColor"))
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchResult()
}
