//
//  StringExtension.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

extension String {
    func formattedName() -> String {
        return self.replacingOccurrences(of: "-", with: " ").capitalized
    }
}
