//
//  Resource.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

struct Resource: Codable {
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
