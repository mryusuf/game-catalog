//
//  GameDetailRepository.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import Foundation

protocol GameDetailRepository: RemoteRepository {
    func fetchGameDetail(id: Int) async -> Result<GameDetailResponse, Error>
}

struct GameDetailRepositoryDefault: GameDetailRepository {
    
    var session: URLSession
    var endpoint: Endpoint
    
    init(session: URLSession, endpoint: Endpoint = Endpoints.gameDetail) {
        self.session = session
        self.endpoint = endpoint
    }
    
    func fetchGameDetail(id: Int) async -> Result<GameDetailResponse, Error> {
        guard var urlComponents = URLComponents(string: "\(endpoint.urlString)/\(id)") else {
            return .failure(APIError.invalidURL)
        }
        
        let queryItems: [URLQueryItem] = [
            endpoint.key
        ]
        
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
            
            let gameDetailResponse = try JSONDecoder().decode(GameDetailResponse.self, from: data)
            
            return .success(gameDetailResponse)
            
        } catch (let e) {
            return .failure(e)
        }
    }
}
