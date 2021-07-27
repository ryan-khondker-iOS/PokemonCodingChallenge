//
//  ParsingError.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

enum ParsingError: Error {
    case objectNotDictionary
    case noObjectForKey(String)
    case badData
    case invalidID
}
