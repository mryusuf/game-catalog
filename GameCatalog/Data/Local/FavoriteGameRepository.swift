//
//  FavoriteGameRepository.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import CoreData
import UIKit

protocol FavoriteGameRepository: LocalRepository {
    func fetchFavoriteGames() -> NSFetchedResultsController<FavoriteGame>?
    func saveFavoriteGame(
        id: Int,
        name: String,
        imageData: Data?,
        publisher: String,
        releaseDate: String,
        rating: String,
        playedCount: String,
        description: String
    )
    func deleteFavoriteGame(gameId: Int)
    func checkGameIsFavorite(gameId: Int) -> Bool
}

struct FavoriteGameRepositoryDefault: FavoriteGameRepository {
    var context: NSManagedObjectContext?
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    init(fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    func fetchFavoriteGames() -> NSFetchedResultsController<FavoriteGame>? {
        guard let context else { return nil }
        
        let favoriteGamesFetch: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(FavoriteGame.createdAt), ascending: false)
        favoriteGamesFetch.sortDescriptors = [sortByDate]
        
        let controller = NSFetchedResultsController(
            fetchRequest: favoriteGamesFetch, managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate

        do {
            try controller.performFetch()
        } catch {
            print("Fetch failed")
        }

        return controller
    }
    
    func saveFavoriteGame(
        id: Int,
        name: String,
        imageData: Data?,
        publisher: String,
        releaseDate: String,
        rating: String,
        playedCount: String,
        description: String
    ) {
        guard let context else { return }
        
        let newGame = FavoriteGame(context: context)
        newGame.setValue(Date(), forKey: #keyPath(FavoriteGame.createdAt))
        newGame.setValue(id, forKey: #keyPath(FavoriteGame.gameId))
        newGame.setValue(name, forKey: #keyPath(FavoriteGame.name))
        newGame.setValue(description, forKey: #keyPath(FavoriteGame.gameDescription))
        newGame.setValue(publisher, forKey: #keyPath(FavoriteGame.publishers))
        newGame.setValue(rating, forKey: #keyPath(FavoriteGame.rating))
        newGame.setValue(releaseDate, forKey: #keyPath(FavoriteGame.releaseDate))
        newGame.setValue(imageData, forKey: #keyPath(FavoriteGame.image))
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func deleteFavoriteGame(gameId: Int) {
        let favoriteGameFetch: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        favoriteGameFetch.fetchLimit =  1
        favoriteGameFetch.predicate = NSPredicate(format: "gameId == %d", gameId)

        do {
            let results = try context?.fetch(favoriteGameFetch) ?? []
            
            guard let game = results.first else {
                return
            }
            
            context?.delete(game)
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkGameIsFavorite(gameId: Int) -> Bool {
        let favoriteGameFetch: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        favoriteGameFetch.fetchLimit =  1
        favoriteGameFetch.predicate = NSPredicate(format: "gameId == %d", gameId)

        do {
            let count = try context?.count(for: favoriteGameFetch) ?? 0
            
            if count > 0 {
                return true
            }
            
            return false
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}
