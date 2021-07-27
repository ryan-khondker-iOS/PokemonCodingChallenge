//
//  ApiService.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

class ApiService {
    /**
        This method is used to query PokeAPI to fetch an array of results
        (with each object containing the Pokemon name and API URL).
        If we get a valid response back from the API, we then convert it to
        a PokemonResults object and pass the object when we call the completion.
        If we get an error, then we pass the error when we call the completion
        - parameter urlString: the URL to fetch the results
        - parameter completion: the completion block to be called once the API call is complete or if there are errors when making the API call
    */
    class func getPokemonResults(urlString: String, completion: @escaping (Result<PokemonResults, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(NetworkError.httpError(code: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let pokemonResults = try JSONDecoder().decode(PokemonResults.self, from: data)
                completion(.success(pokemonResults))
                return
            }
            catch let error {
                completion(.failure(error))
                return
            }
        }
        
        task.resume()
    }
    
    /**
        This method is used to query PokeAPI to fetch a specific Pokemon
        with the given URL. If we get a valid response back from the API,
        we then convert it to a Pokemon object and pass the object
        when we call the completion. If we get an error, then we pass the error
        when we call the completion
        - parameter urlString: the URL to fetch the results
        - parameter completion: the completion block to be called once the API call is complete or if there are errors when making the API call
     */
    class func getPokemonDataFromUrl(urlString: String, completion: @escaping (Result<Pokemon, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.badResponse))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.httpError(code: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                guard let pokemonDictionary = jsonObject as? [String: Any] else {
                    completion(.failure(ParsingError.objectNotDictionary))
                    return
                }
                guard let pokemon = Pokemon(dictionary: pokemonDictionary) else {
                    completion(.failure(ParsingError.badData))
                    return
                }
                
                completion(.success(pokemon))
            }
            catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
