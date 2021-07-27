//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak private var pokemonImageView: UIImageView!
    @IBOutlet weak private var pokemonLabel: UILabel!
    
    lazy var session = URLSession(configuration: .default)
    
    func setCell(pokemonResource: PokemonResource) {
        pokemonLabel.text = "\(pokemonResource.id). \(pokemonResource.resource.name)"
        
        let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonResource.id).png"
        setupImage(imageUrl: imageUrl)
    }
    
    private func setupImage(imageUrl: String) {
        session.invalidateAndCancel()
        session = URLSession(configuration: .default)
        ImageService.getImage(imageUrl: imageUrl, session: session) { [weak self] result in
            guard let strongSelf = self,
                  case let .success(pokemonImage) = result else { return }
            DispatchQueue.main.async {
                strongSelf.pokemonImageView.image = pokemonImage
            }
        }
    }
}
