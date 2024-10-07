//
//  CarouselView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

import SwiftUI

struct Item: Identifiable {
    private(set) var id: UUID = .init()
    var image: String
    var title: String
}

struct CarouselView<Content: View, TitleContent: View, Item: RandomAccessCollection, Id>: View where Item: MutableCollection, Item.Element: Identifiable, Id: Hashable {
    /// Customization Properties
    var showsIndicator: ScrollIndicatorVisibility = .hidden
    var showPagingControl: Bool = true
    var pagingControlSpacing: CGFloat = 20
    var spacing: CGFloat = 10
    
    @Binding var data: Item
    var id: KeyPath<Item.Element, Id>
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    
    var body: some View {
        VStack(spacing: pagingControlSpacing) {
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach($data) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                            content(item)
                        }
                    }
                }
            }
            .scrollIndicators(showsIndicator)
        }
            

        
    }
}
//
//#Preview {
//    CarouselView()
//}
