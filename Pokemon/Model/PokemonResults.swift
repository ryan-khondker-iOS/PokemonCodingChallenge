//
//  PokemonResults.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

struct PokemonResults: Codable {
    var results: [Resource]
    var nextUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case results
        case nextUrl = "next"
    }
}
