//
//  GameResponse.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import Foundation

struct GameResponse: Decodable {
    let count: Int
    let next: String?
    let results: [Game]
    
}

struct Game: Decodable {
    let id: Int?
    let name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let addedByStatus: AddedByStatus?
    let shortScreenshots: [ShortScreenshot]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case addedByStatus = "added_by_status"
        case shortScreenshots = "short_screenshots"
    }
}

struct AddedByStatus: Decodable {
    let yet, owned, beaten, toplay: Int?
    let dropped, playing: Int?
}

struct ShortScreenshot: Decodable {
    let id: Int?
    let image: String?
}
