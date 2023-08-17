//
//  LocalRepository.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import CoreData

protocol LocalRepository {
    var context: NSManagedObjectContext? { get }
}
