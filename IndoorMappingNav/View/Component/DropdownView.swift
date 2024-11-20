//
//  DropdownView.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 19/11/24.
//

import SwiftUI

struct DropdownView: View {
    @Binding var selectedOption: String
    @State private var isDropdownExpanded: Bool = false
    @EnvironmentObject var vm: HomeViewModel
    
    let options = ["Jakarta Mall", "Apple Developer Academy"]
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isDropdownExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedOption)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color("TextIcon"))
                    Spacer()
                    Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("TextIcon"))
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .cornerRadius(10)
            }
            
            if isDropdownExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                selectedOption = option
                                isDropdownExpanded = false
                            }
                            //MARK: temporary, nanti buat berdasarkan array aja
                            if selectedOption == "Jakarta Mall" {
                                vm.mallId = "1"
                            } else {
                                vm.mallId = "-1"
                            }
                        }) {
                            Text(option)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color("TextIcon"))
                        }
                    }
                }
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .padding(.horizontal)
    }
}
