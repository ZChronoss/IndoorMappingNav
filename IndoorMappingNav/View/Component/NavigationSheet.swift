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
        VStack {
            HStack(alignment: .center) {
                Text(String(distance))
                    .font(.system(.title2))
                    .foregroundColor(Color.blue)
                    .fontWeight(.bold)
                
                Text("min walk")
                    .font(.system(.title2))
                    .foregroundColor(Color.blue)
                
                Spacer()
                
                NavigateButton()
            }
        }
        .frame(minHeight: 100)
    }
}

#Preview {
    NavigationSheet(distance: 7)
}
