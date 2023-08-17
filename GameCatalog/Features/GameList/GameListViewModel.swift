//
//  GameListViewModel.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import Foundation

protocol GameListViewModel {
    var gameList: [GameTVModel] { get }
    var gameSearchResults: [GameTVModel] { get }
    var errorMessage: String { get }
    var isSearchMode: Bool { get set }
    var nextURL: String? { get }
    var nextSearchURL: String? { get }
    
    func fetchGameList() async
    func fetchNextGameList() async
    func fetchSearchGame(query: String) async
    func fetchNextSearchGame(query: String) async
}

final class GameListViewModelDefault: GameListViewModel {
    let remoteRepository: GameListRepository
    var gameList: [GameTVModel] = []
    var gameSearchResults: [GameTVModel] = []
    var errorMessage: String = ""
    var isSearchMode: Bool = false
    var nextURL: String?
    var nextSearchURL: String?
    
    private var query = ""
    private var page = 1
    private var pageSize = 10
    
    init(remoteRepository: GameListRepository = GameListRepositoryDefault(session: URLSession.shared)) {
        self.remoteRepository = remoteRepository
    }
    
    func fetchGameList() async {
        errorMessage = ""
        
        let result = await remoteRepository.fetchGameList(page: page, pageSize: pageSize, query: nil)
        handleResult(result)
    }
    
    func fetchNextGameList() async {
        guard let nextURL else { return }
        
        errorMessage = ""
        
        let result = await remoteRepository.fetchNextGameList(urlString: nextURL)
        handleResult(result)
    }
    
    func fetchSearchGame(query: String) async {
        errorMessage = ""
        
        if query != self.query {
            gameSearchResults = []
        }
        
        self.query = query
        
        let result = await remoteRepository.fetchGameList(page: page, pageSize: pageSize, query: query)
        handleSearchResult(result)
    }
    
    func fetchNextSearchGame(query: String) async {
        guard let nextSearchURL else {
            print("no next")
            return
            
        }
        let result = await remoteRepository.fetchNextGameList(urlString: nextSearchURL)
        handleSearchResult(result)
    }
    
    private func handleResult(_ result: Result<GameResponse, Error>) {
        switch result {
        case .success(let gameResponse):
            print(gameResponse)
            gameList.append(contentsOf: gameResponse.results.map { game in
                
                return GameTVModel(
                    id: game.id ?? 0,
                    imageURL: URL(string: game.backgroundImage ?? ""),
                    name: game.name ?? "",
                    releaseDate: game.released ?? "",
                    rating: game.rating?.description ?? ""
                )
            })
            
            self.nextURL = gameResponse.next
            
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    private func handleSearchResult(_ result: Result<GameResponse, Error>) {
        switch result {
        case .success(let gameResponse):
            gameSearchResults.append(contentsOf: gameResponse.results.map { game in
                return GameTVModel(
                    id: game.id ?? 0,
                    imageURL: URL(string: game.backgroundImage ?? ""),
                    name: game.name ?? "",
                    releaseDate: game.released ?? "",
                    rating: game.rating?.description ?? ""
                )
            })
            self.nextSearchURL = gameResponse.next
            
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
