//
//  PopUp.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 17/10/24.
//

import SwiftUI

struct PopUp: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Triangle()
                .rotation(Angle(degrees: 180))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundStyle(.white)
                .frame(width: 25, height: 20)
            
            HStack(spacing: 4){
                Image(systemName: "figure.stand.dress.line.vertical.figure")
                    .foregroundStyle(.toilet)
                    .font(.system(.caption2))
                
                Text("Uniqlo")
                    .font(.system(.caption2))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.bottom, 15)
            
        }
        .shadow(radius: 4, x: 0, y: 1)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

#Preview {
    PopUp()
}
