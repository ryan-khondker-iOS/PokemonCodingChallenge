//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import UIKit

protocol PokemonListViewModelDelegate: class {
    func didGetPokemonResults()
    func didGetError(_ error: Error)
}

class PokemonListViewModel {
    static let initialUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    var pokemonResources: [PokemonResource] = []
    var nextUrl: String?
    
    weak var delegate: PokemonListViewModelDelegate?
    
    func fetchInitialResults() {
        ApiService.getPokemonResults(urlString: PokemonListViewModel.initialUrl, completion: handleResults(_:))
    }
    
    func fetchNextResults() {
        guard canContinueFetching,
              let nextUrl = nextUrl else {
            delegate?.didGetPokemonResults()
            return
        }
        
        ApiService.getPokemonResults(urlString: nextUrl, completion: handleResults(_:))
    }
    
    func showDetailPage(navigationController: UINavigationController, pokemonResource: PokemonResource) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let pokemonDetailsVC = storyboard.instantiateViewController(withIdentifier: "PokemonDetailsVC") as? PokemonDetailsViewController else {
            fatalError("PokemonDetailsVC does not exist")
        }
        pokemonDetailsVC.viewModel = PokemonDetailsViewModel(pokemonUrl: pokemonResource.resource.url)
        pokemonDetailsVC.viewModel?.delegate = pokemonDetailsVC
        navigationController.pushViewController(pokemonDetailsVC, animated: true)
    }
    
    var canContinueFetching: Bool {
        return pokemonResources.count < 300
    }
    
    private func handleResults(_ result: Result<PokemonResults, Error>) {
        switch result {
        case let .failure(error):
            delegate?.didGetError(error)
        case let .success(pokemonResults):
            guard !pokemonResults.results.isEmpty else {
                delegate?.didGetError(NetworkError.noResults)
                return
            }
            let pokemonResources = pokemonResults.results.compactMap { result -> PokemonResource in
                let formattedName = result.name.formattedName()
                return PokemonResource(name: formattedName, url: result.url, id: Int(result.url.dropFirst(34).dropLast()) ?? 0)
            }
            self.pokemonResources.append(contentsOf: pokemonResources)
            nextUrl = pokemonResults.nextUrl
            delegate?.didGetPokemonResults()
        }
    }
}
