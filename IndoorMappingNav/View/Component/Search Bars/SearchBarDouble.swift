//
//  SearchBarDouble.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import SwiftUI

struct SearchBarDouble: View {
    enum SearchBarType {
        case start
        case destination
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: SearchBarType?
    
    @Binding var searchText: String
    @Binding var searchText2: String
    
    var startStoreFloor: String = ""
    var destStoreFloor: String = ""
    
    let action: (_ type: SearchBarType) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .bold()
                    .foregroundStyle(Color("TextIcon"))
            }
            .padding(.top, 18)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading){
                SearchBar(searchText: $searchText,
                          image: Image(systemName: "location.fill"),
                          iconColor: .blue500,
                          placeholder: "Where is your location?",
                          label: startStoreFloor
                )
                .focused($focusedField, equals: .start)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(focusedField == .start ? .blue500 : .clear, lineWidth: 1)
                }
                
                VStack(alignment: .leading){
                    Circle()
                    Circle()
                    Circle()
                }
                .frame(width: 3)
                .foregroundStyle(.blue500)
                .padding(.leading, 25)
                
                SearchBar(searchText: $searchText2,
                          image: Image(systemName: "mappin.and.ellipse"),
                          iconColor: .blue500,
                          placeholder: "Where to?",
                          label: destStoreFloor
                )
                .focused($focusedField, equals: .destination)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(focusedField == .destination ? .blue500 : .clear, lineWidth: 1)
                }
            }
        }
        .onAppear() {
            focusedField = .start
            action(.start)
        }
        .onChange(of: focusedField ?? .start) { _, val in
            action(val)
        }
    }
}

#Preview {
    SearchBarDouble(searchText: .constant(""), searchText2: .constant("")) { _ in
        
    }
}
