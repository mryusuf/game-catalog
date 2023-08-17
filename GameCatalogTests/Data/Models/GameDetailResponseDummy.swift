//
//  GameDetailResponseDummy.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 17/08/23.
//

@testable import GameCatalog
import Foundation

struct GameDetailResponseDummy {
    static let jsonData = """
    {
        "id": 3498,
        "name": "Grand Theft Auto V",
        "released": "2013-09-17",
        "rating": 4.47,
        "background_image": "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
        "added_by_status": {
            "yet": 511,
            "owned": 11463,
            "beaten": 5570,
            "toplay": 593,
            "dropped": 1043,
            "playing": 705
        },
        "publishers": [
            {
                "id": 2155,
                "name": "Rockstar Games",
                "slug": "rockstar-games",
                "games_count": 79,
                "image_background": "https://media.rawg.io/media/games/511/5118aff5091cb3efec399c808f8c598f.jpg"
            }
        ],
        "description_raw": "Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas. 561 different vehicles "
    }
    """
    
    static func makeGameDetailResponse() -> GameDetailResponse {
        let data = Data(GameDetailResponseDummy.jsonData.utf8)
        return try! JSONDecoder().decode(GameDetailResponse.self, from: data)
    }
}
