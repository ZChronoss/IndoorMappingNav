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
            VStack {
                Image(store?.category?.image ?? "other")
                    .resizable()
                    .frame(width: 23, height: 23)
                    .foregroundStyle(store?.category?.color ?? .other)
                    .padding(10)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 8, x: 0, y: 0)
            }
            .background(.neutral9)
            .clipShape(Circle())
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 8, x: 0, y: 0)
            
            VStack(alignment: .leading) {
                Text(store?.name ?? "Error: No Store Name")
                    .font(.system(.headline))
                
                Text("Between Nike and Adidas")
                    .font(.system(.caption, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(FloorAbbreviation.getFloorAbbreviation(floor: store?.floor ?? "Basement"))
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchResult()
}
