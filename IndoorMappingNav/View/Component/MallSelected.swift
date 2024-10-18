//
//  MallSelected.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct MallSelected: View {
    @State var selectedMall = "Summarecon Mall Serpong"
    @State var isExpanded: Bool = false
    var malls: [String] = [
        "Lippo Mall Puri",
        "Summarecon Mall Serpong",
        "Tangerang City Mall"
    ]
    
    var body: some View {
        ZStack {
            
        }
        DisclosureGroup(selectedMall, isExpanded: $isExpanded) {
            VStack {
                ForEach(malls, id: \.self) { mall in
                    Text(mall)
                        .padding()
                        .onTapGesture {
                            selectedMall = mall
                            isExpanded = false
                        }
                }
            }
        }
        .padding()
//        .foregroundStyle(.black)
        .tint(.black)
        
        
        Menu {
            ForEach(malls, id: \.self) { mall in
                Button(mall) {
                    selectedMall = mall
                }
            }
        } label: {
            HStack {
                Text(selectedMall)
                Spacer()
                Image(systemName: "chevron.down")
            }
        }
        .padding()
        .foregroundStyle(.black)
    }
}

#Preview {
    MallSelected()
}
