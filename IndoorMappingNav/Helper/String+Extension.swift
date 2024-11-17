//
//  Untitled.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 08/11/24.
//

import Foundation

extension String {
    func removeUnderscores() -> String {
        return self.replacingOccurrences(of: "_", with: "")
    }
    
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeSpecialCharacters() -> String {
        return self
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
