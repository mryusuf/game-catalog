//
//  Errors.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case httpCode(Int)
    case unexpectedResponse
    case imageDeserialization
}
