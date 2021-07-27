//
//  NetworkError.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badResponse
    case httpError(code: Int)
    case noData
    case badData
    case noResults
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString("Error fetching data", comment: "")
    }
}
