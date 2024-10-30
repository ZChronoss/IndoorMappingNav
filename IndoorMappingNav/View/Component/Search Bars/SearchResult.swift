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
            
            Text(getFloorAbbreviation(floor: store?.floor ?? "Basement"))
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
    }
}

extension SearchResult {
    func getFloorAbbreviation(floor: String) -> String {
        switch floor {
        case "Ground Floor" : return "GF"
        case "1st Floor"    : return "1st"
        case "2nd Floor"    : return "2nd"
        case "3rd Floor"    : return "3rd"
        default:
            var defaultVal = ""
            
            if floor.hasPrefix("Basement") {
                defaultVal = "B"
            }
            
            return defaultVal
        }
    }
}

#Preview {
    SearchResult()
}
