//
//  ToiletIcon.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 17/10/24.
//

import SwiftUI

struct ToiletIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 22, height: 22)
            
            Image("toiletWhite")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
        }
    }
}

#Preview {
    ToiletIcon()
}
