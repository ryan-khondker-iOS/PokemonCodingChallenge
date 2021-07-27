//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import UIKit

class PokemonListViewController: UIViewController {
    static let cellIdentifier = "PokemonCell"
    
    @IBOutlet weak private var tableView: UITableView!
    
    let viewModel = PokemonListViewModel()
    let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokemon List"
        
        viewModel.delegate = self
        setupLoadingIndicator()
        setupTableView()
        
        loadingIndicator.startAnimating()
        viewModel.fetchInitialResults()
    }
}

// MARK: - UITableViewDataSource
extension PokemonListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonResources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pokemonCell = tableView.dequeueReusableCell(withIdentifier: PokemonListViewController.cellIdentifier) as? PokemonTableViewCell else {
            fatalError("PokemonCell does not exist")
        }
        
        guard (0..<viewModel.pokemonResources.count).contains(indexPath.row) else {
            return pokemonCell
        }
        let pokemonResource = viewModel.pokemonResources[indexPath.row]
        
        pokemonCell.setCell(pokemonResource: pokemonResource)
        return pokemonCell
    }
}

// MARK: - UITableViewDelegate
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let navController = navigationController,
              (0..<viewModel.pokemonResources.count).contains(indexPath.row) else { return }
        viewModel.showDetailPage(navigationController: navController, pokemonResource: viewModel.pokemonResources[indexPath.row])
    }
    
    // Using this method to fetch the next page of results if we reach the last cell
    // in the table view (paging)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.canContinueFetching && indexPath.row == viewModel.pokemonResources.count - 1 {
            loadingIndicator.startAnimating()
            viewModel.fetchNextResults()
        }
    }
}

// MARK: - PokemonListViewModelDelegate
extension PokemonListViewController: PokemonListViewModelDelegate {
    func didGetPokemonResults() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func didGetError(_ error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.present(alertVC, animated: true)
        }
    }
}

// MARK: - Private Setup Methods
private extension PokemonListViewController {
    func setupLoadingIndicator() {
        loadingIndicator.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        view.addSubview(loadingIndicator)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        registerTableViewCell()
    }
    
    func registerTableViewCell() {
        let bundle = Bundle(for: PokemonTableViewCell.self)
        let nib = UINib(nibName: "PokemonTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: PokemonListViewController.cellIdentifier)
    }
}
