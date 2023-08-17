//
//  GameDetailViewModel.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import UIKit

protocol GameDetailViewModel {
    var gameDetail: GameDetailModel? { get }
    var errorMessage: String { get }
    var isFavorite: Bool { get }
    
    func fetchGameDetail() async
    func saveFavoriteGame()
    func deleteFavoriteGame()
    func checkGameIsFavorite() -> Bool
}

final class GameDetailViewModelDefault: GameDetailViewModel {
    private let remoteRepository: GameDetailRepository
    private let localRepository: FavoriteGameRepository
    var gameDetail: GameDetailModel?
    var errorMessage: String = ""
    var gameId: Int
    var isFavorite: Bool = false
    
    init (
        gameId: Int,
        gameDetail: GameDetailModel? = nil,
        remoteRepository: GameDetailRepository = GameDetailRepositoryDefault(session: URLSession.shared),
        localRepository: FavoriteGameRepository = FavoriteGameRepositoryDefault(fetchedResultsControllerDelegate: nil)
    ) {
        self.gameId = gameId
        self.gameDetail = gameDetail
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    func fetchGameDetail() async {
        guard gameDetail == nil else { return }
        
        let result = await remoteRepository.fetchGameDetail(id: gameId)
        
        switch result {
        case .success(let gameDetailResponse):
            
            gameDetail = GameDetailModel(
                id: gameDetailResponse.id ?? 0,
                name: gameDetailResponse.name ?? "",
                imageURL: URL(string: gameDetailResponse.backgroundImage ?? ""),
                imageData: nil,
                publisher: gameDetailResponse.publishers?.map { $0.name }.joined(separator: ", ") ?? "",
                releaseDate: gameDetailResponse.released ?? "",
                rating: gameDetailResponse.rating?.description ?? "",
                playedCount: gameDetailResponse.addedByStatus?.playing?.description ?? "",
                description: gameDetailResponse.description ?? "")
            
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    func checkGameIsFavorite() -> Bool {
        isFavorite = localRepository.checkGameIsFavorite(gameId: gameId)
        return isFavorite
    }
    
    func saveFavoriteGame() {
        guard let gameDetail else { return }
        
        var imageData: Data?
        
        if let imageURL = gameDetail.imageURL {
            if let image = imageCaches.object(forKey: imageURL as NSURL) as? UIImage, let data = image.pngData() {
                imageData = data
            } else if let data = try? Data(contentsOf: imageURL) {
                imageData = data
            }
        }
        
        localRepository.saveFavoriteGame(
            id: gameDetail.id,
            name: gameDetail.name,
            imageData: imageData,
            publisher: gameDetail.publisher,
            releaseDate: gameDetail.releaseDate,
            rating: gameDetail.rating,
            playedCount: gameDetail.playedCount,
            description: gameDetail.description
        )
        
        isFavorite = true
    }
    
    func deleteFavoriteGame() {
        guard let gameDetail else { return }
        
        localRepository.deleteFavoriteGame(gameId: gameDetail.id)
        
        isFavorite = false
    }
}
