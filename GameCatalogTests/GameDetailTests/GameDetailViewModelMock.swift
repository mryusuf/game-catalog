//
//  GameDetailViewModelMock.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 16/08/23.
//

import Foundation
@testable import GameCatalog

final class GameDetailViewModelMock: GameDetailViewModel {
    var gameDetail: GameCatalog.GameDetailModel?
    
    var isFavorite: Bool = false
    let remoteRepository: GameDetailRepository
    var errorMessage: String = ""
    
    
    init(remoteRepository: GameDetailRepository = GameDetailRepositoryDefault(session: URLSession.shared)) {
        self.remoteRepository = remoteRepository
    }
    
    func fetchGameDetail(id: Int) async {
        let result = await remoteRepository.fetchGameDetail(id: id)
        
        switch result {
        case .success(let gameDetailResponse):
            print(gameDetailResponse)
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    
    func fetchGameDetail() async {
        await withCheckedContinuation { continuation in
            let gameDetailResponseDummy = GameDetailResponseDummy.makeGameDetailResponse()
            
            gameDetail = GameDetailModel(
                id: gameDetailResponseDummy.id ?? 0,
                name: gameDetailResponseDummy.name ?? "",
                imageURL: URL(string: gameDetailResponseDummy.backgroundImage ?? ""),
                imageData: nil,
                publisher: gameDetailResponseDummy.publishers?.map { $0.name }.joined(separator: ", ") ?? "",
                releaseDate: gameDetailResponseDummy.released ?? "",
                rating: gameDetailResponseDummy.rating?.description ?? "" ,
                playedCount: gameDetailResponseDummy.addedByStatus?.playing?.description ?? "",
                description: gameDetailResponseDummy.description ?? "")
            
            continuation.resume()
        }
    }
    
    func saveFavoriteGame() {
        
    }
    
    func deleteFavoriteGame() {
        
    }
    
    func checkGameIsFavorite() -> Bool {
        return false
    }
    
}
