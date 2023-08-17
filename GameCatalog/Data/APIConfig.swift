//
//  APIConfig.swift
//  GameCatalog
//
//  Created by Indra Permana on 14/08/23.
//

import Foundation

public struct APIConfig {
    enum Keys {
        static let baseURL = "BASE_URL"
        static let apiKey = "API_KEY"
    }
    
    static let baseURL: String = {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL) as? String else {
            return ""
        }
        return baseURLProperty
    }()
    
    static let apiKey: String = {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: Keys.apiKey) as? String else {
            return ""
        }
        return baseURLProperty
    }()
}
