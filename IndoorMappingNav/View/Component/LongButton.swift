//
//  LongButton.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 23/10/24.
//

import SwiftUI

struct LongButton: View {
    var body: some View {
        Button(action: {
            
        }) {
            Text("View Route")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(minWidth: 344, minHeight: 42, alignment: .center)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(.blue600)
        )
    }
}

#Preview {
    LongButton()
}
