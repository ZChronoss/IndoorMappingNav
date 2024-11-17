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
    
    let instructionSheetDown: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                dismiss()
                instructionSheetDown()
            } label: {
                Image(systemName: "chevron.left")
                    .bold()
                    .foregroundStyle(Color("TextIcon"))
            }
            .padding(.top, 12)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading){
                SearchBar(searchText: $searchText,
                          image: Image(systemName: "location.fill"),
                          iconColor: .blue500,
                          placeholder: "Where is your location?",
                          label: startStoreFloor,
                          backgroundColor: focusedField == .start ? .highlightSearchBar : .bGnSB
                )
                .focused($focusedField, equals: .start)
                .onTapGesture {
                    action(.start)
                }
                
                VStack(alignment: .leading, spacing: 4){
                    Circle()
                    Circle()
                    Circle()
                }
                .frame(width: 4)
                .foregroundStyle(.blue500)
                .padding(.leading, 20)
                
                SearchBar(searchText: $searchText2,
                          image: Image(systemName: "mappin.and.ellipse"),
                          iconColor: .blue500,
                          placeholder: "Where to?",
                          label: destStoreFloor,
                          backgroundColor: focusedField == .destination ? .highlightSearchBar : .bGnSB
                )
                .focused($focusedField, equals: .destination)
                .onTapGesture {
                    action(.destination)
                }
            }
        }
        .onAppear() {
            focusedField = .start
            action(.start)
        }
//        .onChange(of: focusedField ?? .start) { _, val in
//            action(val)
//        }
    }
}

#Preview {
    SearchBarDouble(searchText: .constant(""), searchText2: .constant("")) { _ in
        
    } instructionSheetDown: {
        
    }
}
