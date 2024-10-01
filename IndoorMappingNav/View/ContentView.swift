//
//  ContentView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 01/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MallScene()
                .ignoresSafeArea(.all)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
