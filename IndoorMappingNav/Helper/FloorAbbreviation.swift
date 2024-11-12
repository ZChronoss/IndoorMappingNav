//
//  FloorAbbreviation.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 12/11/24.
//

import Foundation

class FloorAbbreviation {
    static func getFloorAbbreviation(floor: String) -> String {
        switch floor {
        case "Ground Floor" : return "GF"
        case "1st Floor"    : return "1st"
        case "2nd Floor"    : return "2nd"
        case "3rd Floor"    : return "3rd"
        default:
            var defaultVal = ""
            
            if floor.hasPrefix("Basement") {
                defaultVal = "B"
            }
            
            return defaultVal
        }
    }
}
