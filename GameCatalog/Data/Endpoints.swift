//
//  Endpoints.swift
//  GameCatalog
//
//  Created by Indra Permana on 14/08/23.
//

import Foundation

protocol Endpoint {
    var urlString: String { get }
    var httpMethod: String { get }
    var headers: [String: String]? { get }
    var key: URLQueryItem { get }
}

enum Endpoints: Endpoint {
    case gameList
    case search
    case gameDetail
    
    var urlString: String {
        return "\(APIConfig.baseURL)/api/games"
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var key: URLQueryItem {
        return URLQueryItem(name: "key", value: APIConfig.apiKey)
    }
    
//    var queryItems: [URLQueryItem] {
//        switch self {
//        case .gameList:
//            return [
//                URLQueryItem(name: "page", value: "1"),
//                URLQueryItem(name: "page_size", value: "5")
//            ]
//        case .search:
//            <#code#>
//        case .gameDetail:
//            <#code#>
//        }
//    }
//
//    func urlRequest(baseURL: String) -> URLRequest? {
//        guard let url = URL(string: urlString) else {
//            return nil
//        }
//        url.append(queryItems: <#T##[URLQueryItem]#>)
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod
//        request.allHTTPHeaderFields = headers
//        request.url?.append(queryItems: <#T##[Foundation.URLQueryItem]#>)
//        return request
//    }
}
