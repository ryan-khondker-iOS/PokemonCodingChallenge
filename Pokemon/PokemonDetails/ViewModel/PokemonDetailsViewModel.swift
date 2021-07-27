//
//  PokemonDetailsViewModel.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

protocol PokemonDetailsViewModelDelegate: class {
    func didGetPokemonDetails()
    func didGetError(_ error: Error)
}

class PokemonDetailsViewModel {
    let pokemonUrl: String
    var pokemon: Pokemon?
    
    weak var delegate: PokemonDetailsViewModelDelegate?
    
    init(pokemonUrl: String) {
        self.pokemonUrl = pokemonUrl
    }
    
    func fetchPokemonDetails() {
        ApiService.getPokemonDataFromUrl(urlString: pokemonUrl) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didGetError(error)
            case let .success(pokemon):
                strongSelf.pokemon = pokemon
                strongSelf.delegate?.didGetPokemonDetails()
            }
        }
    }
}
