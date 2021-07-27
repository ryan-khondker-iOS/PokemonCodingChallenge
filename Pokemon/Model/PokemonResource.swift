//
//  PokemonResource.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

struct PokemonResource {
    let resource: Resource
    let id: Int
    
    init(name: String, url: String, id: Int) {
        self.resource = Resource(name: name, url: url)
        self.id = id
    }
}
