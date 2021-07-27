//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    @IBOutlet weak private var pokemonImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var idLabel: UILabel!
    @IBOutlet weak private var baseExpLabel: UILabel!
    @IBOutlet weak private var abilitiesHeaderLabel: UILabel!
    @IBOutlet weak private var abilitiesLabel: UILabel!
    @IBOutlet weak private var formsHeaderLabel: UILabel!
    @IBOutlet weak private var formsLabel: UILabel!
    @IBOutlet weak private var movesHeaderLabel: UILabel!
    @IBOutlet weak private var movesLabel: UILabel!
    
    var viewModel: PokemonDetailsViewModel?
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var session = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokemon Details"
        
        setupLoadingIndicator()
        
        loadingIndicator.startAnimating()
        viewModel?.fetchPokemonDetails()
    }
}

extension PokemonDetailsViewController: PokemonDetailsViewModelDelegate {
    func didGetPokemonDetails() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.setupView()
        }
    }
    
    func didGetError(_ error: Error) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
        showErrorAlertWithMessage(error.localizedDescription)
    }
}

// MARK: - Private Helper Methods
private extension PokemonDetailsViewController {
    func setupLoadingIndicator() {
        loadingIndicator.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        view.addSubview(loadingIndicator)
    }
    
    func setupView() {
        guard let pokemon = viewModel?.pokemon else {
            showErrorAlertWithMessage("No Pokemon data")
            return
        }
        
        nameLabel.text = pokemon.name
        if let id = pokemon.id {
            idLabel.text = "ID: \(id)"
            
            let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
            setupImage(imageUrl: imageUrl)
        }
        if let baseExp = pokemon.baseExp {
            baseExpLabel.text = "Base Exp: \(baseExp)"
        }
        if let abilities = pokemon.abilities {
            setupAbilitiesLabel(abilities: abilities)
        }
        if let forms = pokemon.forms {
            setupFormsLabel(forms: forms)
        }
        if let moves = pokemon.moves {
            setupMovesLabel(moves: moves)
        }
    }
    
    func setupAbilitiesLabel(abilities: [String]) {
        if abilities.isEmpty {
            abilitiesHeaderLabel.isHidden = true
            abilitiesLabel.text = ""
            return
        }
        
        abilitiesHeaderLabel.isHidden = false
        abilitiesLabel.text = abilities.joined(separator: "\n")
    }
    
    func setupFormsLabel(forms: [String]) {
        if forms.isEmpty {
            formsHeaderLabel.isHidden = true
            formsLabel.text = ""
            return
        }
        
        formsHeaderLabel.isHidden = false
        formsLabel.text = forms.joined(separator: "\n")
    }
    
    func setupMovesLabel(moves: [String]) {
        if moves.isEmpty {
            movesHeaderLabel.isHidden = true
            movesLabel.text = ""
            return
        }
        
        movesHeaderLabel.isHidden = false
        movesLabel.text = moves.joined(separator: "\n")
    }
    
    func setupImage(imageUrl: String) {
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
    
    func showErrorAlertWithMessage(_ message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
}
