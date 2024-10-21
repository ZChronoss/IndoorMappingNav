//
//  SearchResult.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 18/10/24.
//

import SwiftUI

struct SearchResult: View {
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "person.and.background.dotted")
                    .foregroundStyle(.black)
                    .padding(6)
            }
            .background(.red)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Sociolla")
                    .font(.system(.headline))
                
                Text("Between Nike and Adidas")
                    .font(.system(.caption, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("LG")
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(.gray)
        }
        .padding()
    }
}

#Preview {
    SearchResult()
}
