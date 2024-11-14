//
//  Directions.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 21/10/24.
//

import Foundation

class Directions: Identifiable, Equatable {
    let id: UUID = UUID()
    let icon: String
    let instruction: LocalizedStringResource
    let store: String
    
    init(icon: String = "", instruction: LocalizedStringResource = "", store: String = "") {
        self.icon = icon
        self.instruction = instruction
        self.store = store
    }
    
    static func == (lhs: Directions, rhs: Directions) -> Bool {
        return lhs.icon == rhs.icon && lhs.instruction == rhs.instruction
    }
    
    static let left = (icon: "arrow.left", instruction: LocalizedStringResource(stringLiteral: "Go to the **left** side"))
    static let right = (icon: "arrow.right", instruction: LocalizedStringResource(stringLiteral: "Go to the **right** side"))
    static let straight = (icon: "arrow.up", instruction: LocalizedStringResource(stringLiteral: "Keep going **straight**"))
    static let stairUp = (icon: "figure.stairs", instruction: LocalizedStringResource(stringLiteral: "Go to the **escalator**"))
//    static let here = (icon: "mappin.and.ellipse", instruction: LocalizedStringResource(stringLiteral: "You are **here**"))
}

class LeftDirection: Directions {
    init(store: String) {
        super.init(icon: Directions.left.icon, instruction: Directions.left.instruction, store: store)
    }
}

class RightDirection: Directions {
    init(store: String) {
        super.init(icon: Directions.right.icon, instruction: Directions.right.instruction, store: store)
    }
}

class StraightDirection: Directions {
    init(store: String) {
        super.init(icon: Directions.straight.icon, instruction: Directions.straight.instruction, store: store)
    }
}

class StairUpDirection: Directions {
    init(store: String) {
        super.init(icon: Directions.stairUp.icon, instruction: Directions.stairUp.instruction, store: store)
    }
}

//class HereDirection: Directions {
//    init(store: String) {
//        super.init(icon: Directions.here.icon, instruction: Directions.here.instruction, store: store)
//    }
//}
