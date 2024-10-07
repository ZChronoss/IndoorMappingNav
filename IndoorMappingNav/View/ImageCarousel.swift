//
//  AutoSCroller.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import Foundation
import SwiftUI

struct ImageCarousel: View {
    var images: [String]
    @State private var selectedImageIdx: Int = 0
    
    var body: some View {
        TabView(selection: $selectedImageIdx) {
            ForEach(0 ..< images.count, id: \.self) { imageIdx in
                Image(images[imageIdx], label: Text("hai"))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .tag(imageIdx)
                    .padding(.horizontal, 16)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .frame(height: 200)
    }
    
}

#Preview {
    StoreDetailView()
}