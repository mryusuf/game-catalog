//
//  GameDetailModel.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import Foundation

struct GameDetailModel {
    let id: Int
    let name: String
    let imageURL: URL?
    let imageData: Data?
    let publisher: String
    let releaseDate: String
    let rating: String
    let playedCount: String
    let description: String
}
