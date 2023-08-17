//
//  GameDetailResponse.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import Foundation

struct GameDetailResponse: Decodable {
    let id: Int?
    let name, released, description: String?
    let backgroundImage: String?
    let rating: Double?
    let addedByStatus: AddedByStatus?
    let publishers: [Publisher]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case description = "description_raw"
        case backgroundImage = "background_image"
        case rating
        case addedByStatus = "added_by_status"
        case publishers
    }
}

struct Publisher: Decodable {
    let id: Int
    let name: String
}
