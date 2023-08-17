//
//  RemoteRepository.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import Foundation

protocol RemoteRepository {
    var session: URLSession { get }
    var endpoint: Endpoint { get }
}
