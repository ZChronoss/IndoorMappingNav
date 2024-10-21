//
//  SearchBarDouble.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import SwiftUI

struct SearchBarDouble: View {
    @FocusState private var isActive1: Bool
    @FocusState private var isActive2: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            SearchBar(image:
                        Image(systemName: "location.fill"), iconColor: .blue500
            )
            .focused($isActive1)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isActive1 ? .blue500 : .clear, lineWidth: 1)
            }
            
            VStack(alignment: .leading){
                Circle()
                Circle()
                Circle()
            }
            .frame(width: 3)
            .foregroundStyle(.blue500)
            .padding(.leading, 25)
            
            SearchBar(image:
                        Image(systemName: "mappin.and.ellipse"), iconColor: .blue500
            )
            .focused($isActive2)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isActive2 ? .blue500 : .clear, lineWidth: 1)
            }
        }
    }
}

#Preview {
    SearchBarDouble()
}
