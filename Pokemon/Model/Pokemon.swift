//
//  Pokemon.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

struct Pokemon {
    var name: String?
    var id: Int?
    var baseExp: Int?
    var abilities: [String]?
    var forms: [String]?
    var moves: [String]?
    
    init?(dictionary: [String: Any]) {
        if let name = dictionary["name"] as? String {
            self.name = name.formattedName()
        }
        
        self.id = dictionary["id"] as? Int
        self.baseExp = dictionary["base_experience"] as? Int
        
        if let abilities = dictionary["abilities"] as? [[String: Any]] {
            self.abilities = abilities.compactMap { ability in
                if let abilityResource = ability["ability"] as? [String: Any] {
                    return (abilityResource["name"] as? String)?.formattedName()
                }
                return nil
            }
        }
        
        if let forms = dictionary["forms"] as? [[String: Any]] {
            self.forms = forms.compactMap { form in
                return (form["name"] as? String)?.formattedName()
            }
        }
        
        if let moves = dictionary["moves"] as? [[String: Any]] {
            self.moves = moves.compactMap { move in
                if let moveResource = move["move"] as? [String: Any] {
                    return (moveResource["name"] as? String)?.formattedName()
                }
                return nil
            }
        }
    }
}
