//
//  GameListViewModelMock.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 15/08/23.
//

import Foundation
@testable import GameCatalog

final class GameListViewModelMock: GameListViewModel {
    var nextURL: String?
    
    var nextSearchURL: String?
    
    var gameSearchResults: [GameCatalog.GameTVModel] = []
    
    var isSearchMode: Bool = false
    var errorMessage: String = ""
    
    let remoteRepository: GameListRepository
    var gameCount: Int = 0
    var gameList: [GameTVModel] = []
    
    init(remoteRepository: GameListRepository = GameListRepositoryDefault(session: URLSession.shared)) {
        self.remoteRepository = remoteRepository
    }
    
    func fetchGameList() async {
        await withCheckedContinuation { continuation in
            let gameResponseDummy = GameResponseDummy.makeGameResponse()
            
            nextURL = gameResponseDummy.next
            
            gameList = gameResponseDummy.results.map { game in
                GameTVModel(
                    id: game.id ?? 0,
                    imageURL: URL(string: game.backgroundImage ?? ""),
                    name: game.name ?? "",
                    releaseDate: game.released ?? "",
                    rating: game.rating?.description ?? ""
                )
            }
            
            continuation.resume()
        }
    }
    
    func fetchNextGameList() async {
        await withCheckedContinuation { continuation in
            let gameResponseDummy = GameResponseDummy.makeGameResponse()
            
            nextURL = gameResponseDummy.next
            
            gameList.append(contentsOf: gameResponseDummy.results.map { game in
                GameTVModel(
                    id: game.id ?? 0,
                    imageURL: URL(string: game.backgroundImage ?? ""),
                    name: game.name ?? "",
                    releaseDate: game.released ?? "",
                    rating: game.rating?.description ?? ""
                )
            })
            
            continuation.resume()
        }
    }
    
    func fetchSearchGame(query: String) async {
        await withCheckedContinuation { continuation in
            let gameResponseDummy = GameResponseDummy.makeGameResponse()
            
            nextURL = gameResponseDummy.next
            
            gameSearchResults = gameResponseDummy.results.map { game in
                GameTVModel(
                    id: game.id ?? 0,
                    imageURL: URL(string: game.backgroundImage ?? ""),
                    name: game.name ?? "",
                    releaseDate: game.released ?? "",
                    rating: game.rating?.description ?? ""
                )
            }
            
            continuation.resume()
        }
        
    }
    
    func fetchNextSearchGame(query: String) async {
        await withCheckedContinuation { continuation in
            let gameResponseDummy = GameResponseDummy.makeGameResponse()
            
            nextURL = gameResponseDummy.next
            
            gameSearchResults.append(contentsOf: gameResponseDummy.results.map { game in
                GameTVModel(
                    id: game.id ?? 0,
                    imageURL: URL(string: game.backgroundImage ?? ""),
                    name: game.name ?? "",
                    releaseDate: game.released ?? "",
                    rating: game.rating?.description ?? ""
                )
            })
            
            continuation.resume()
        }
        
    }
    
}
