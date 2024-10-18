//
//  NavigationSheet.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 18/10/24.
//

import SwiftUI

struct NavigationSheet: View {
    var distance: Int
    
    var body: some View {
        HStack {
            Text(String(distance))
                .font(.title2)
                .foregroundColor(Color.blue)
                .fontWeight(.bold)
            
            Text("min walk")
                .font(.title2)
                .foregroundColor(Color.blue)
            
            Spacer()
            
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "location.north.fill")
                    
                    Text("Navigate")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.blue)
            )
            .foregroundColor(.white)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationSheet(distance: 7)
}
