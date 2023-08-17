//
//  GameListRepository.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import Foundation

protocol GameListRepository: RemoteRepository {
    func fetchGameList(page: Int, pageSize: Int, query: String?) async -> Result<GameResponse, Error>
    func fetchNextGameList(urlString: String) async -> Result<GameResponse, Error>
}

struct GameListRepositoryDefault: GameListRepository {
    
    var session: URLSession
    var endpoint: Endpoint
    
    init(session: URLSession, endpoint: Endpoint = Endpoints.gameList) {
        self.session = session
        self.endpoint = endpoint
    }
    
    func fetchGameList(page: Int, pageSize: Int, query: String?) async -> Result<GameResponse, Error> {
        guard var urlComponents = URLComponents(string: endpoint.urlString) else {
            return .failure(APIError.invalidURL)
        }
        
        var queryItems: [URLQueryItem] = [
            endpoint.key,
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "page_size", value: "\(pageSize)")
        ]
        
        if let query {
            queryItems.append(URLQueryItem(name: "search", value: query))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return .failure(APIError.invalidURL)
        }
        
        do {
            let (data, response) = try await session.data(for: URLRequest(url: url))
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 201
            
            guard statusCode == 200 else {
                return .failure(APIError.httpCode(statusCode))
            }
            
            let gameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
            
            return .success(gameResponse)
            
        } catch (let e) {
            return .failure(e)
        }

    }
    
    func fetchNextGameList(urlString: String) async -> Result<GameResponse, Error> {
        guard let url = URL(string: urlString) else {
            return .failure(APIError.invalidURL)
        }
        
        do {
            let (data, response) = try await session.data(for: URLRequest(url: url))
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 201
            
            guard statusCode == 200 else {
                return .failure(APIError.httpCode(statusCode))
            }
            
            let gameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
            
            return .success(gameResponse)
            
        } catch (let e) {
            return .failure(e)
        }

    }
}
