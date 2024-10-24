//
//  AutoSCroller.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import Foundation
import SwiftUI

struct ImageCarousel: View {
    var images: [Data?]
    @State private var selectedImageIdx: Int = 0
    
    var body: some View {
        TabView(selection: $selectedImageIdx) {
            ForEach(0 ..< images.count, id: \.self) { imageIdx in
                if let data = images[imageIdx], let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .tag(imageIdx)
                        .padding(.horizontal, 16)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .frame(height: 200)
        .onChange(of: selectedImageIdx) { oldValue, newValue in
            print("hai")
        }
    }
    
}
