//
//  CustomCornerShape.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 09/11/24.
//

import SwiftUI
import Foundation

struct CustomCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
