//
//  Directions.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import Foundation

class Directions: Identifiable {
    let id: UUID = UUID()
    let icon: String
    let instruction: AttributedString
    
    init(icon: String = "", instruction: AttributedString = "") {
        self.icon = icon
        self.instruction = instruction
    }
    
    static let left = (icon: "arrow.left", instruction: try! AttributedString(markdown: "Go to the **left** side"))
    static let right = (icon: "arrow.right", instruction: try! AttributedString(markdown: "Go to the **right** side"))
    static let straight = (icon: "arrow.up", instruction: try! AttributedString(markdown: "Keep going **straight**"))
    static let stairUp = (icon: "figure.stairs", instruction: try! AttributedString(markdown: "Go to the **escalator**"))
    static let here = (icon: "mappin.and.ellipse", instruction: try! AttributedString(markdown: "You are **here**"))
}

class LeftDirection: Directions {
    init() {
        super.init(icon: Directions.left.icon, instruction: Directions.left.instruction)
    }
}

class RightDirection: Directions {
    init() {
        super.init(icon: Directions.right.icon, instruction: Directions.right.instruction)
    }
}

class StraightDirection: Directions {
    init() {
        super.init(icon: Directions.straight.icon, instruction: Directions.straight.instruction)
    }
}

class StairUpDirection: Directions {
    init() {
        super.init(icon: Directions.stairUp.icon, instruction: Directions.stairUp.instruction)
    }
}

class HereDirection: Directions {
    init() {
        super.init(icon: Directions.here.icon, instruction: Directions.here.instruction)
    }
}
