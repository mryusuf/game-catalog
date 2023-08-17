//
//  GameResponseDummy.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 17/08/23.
//
@testable import GameCatalog
import Foundation

struct GameResponseDummy {
    static let jsonData = """
    {
      "count": 852582,
      "next": "https://api.rawg.io/api/games?key=&page=2&page_size=2",
      "results": [
          {
              "id": 3498,
              "slug": "grand-theft-auto-v",
              "name": "Grand Theft Auto V",
              "released": "2013-09-17",
              "background_image": "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
              "rating": 4.47,
              "added": 19885,
              "added_by_status": {
                  "yet": 511,
                  "owned": 11463,
                  "beaten": 5570,
                  "toplay": 593,
                  "dropped": 1043,
                  "playing": 705
              },
              "metacritic": 92,
              "playtime": 74,
              "short_screenshots": [
                  {
                      "id": -1,
                      "image": "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"
                  },
                  {
                      "id": 1827221,
                      "image": "https://media.rawg.io/media/screenshots/a7c/a7c43871a54bed6573a6a429451564ef.jpg"
                  },
                  {
                      "id": 1827222,
                      "image": "https://media.rawg.io/media/screenshots/cf4/cf4367daf6a1e33684bf19adb02d16d6.jpg"
                  },
                  {
                      "id": 1827223,
                      "image": "https://media.rawg.io/media/screenshots/f95/f9518b1d99210c0cae21fc09e95b4e31.jpg"
                  },
                  {
                      "id": 1827225,
                      "image": "https://media.rawg.io/media/screenshots/a5c/a5c95ea539c87d5f538763e16e18fb99.jpg"
                  },
                  {
                      "id": 1827226,
                      "image": "https://media.rawg.io/media/screenshots/a7e/a7e990bc574f4d34e03b5926361d1ee7.jpg"
                  },
                  {
                      "id": 1827227,
                      "image": "https://media.rawg.io/media/screenshots/592/592e2501d8734b802b2a34fee2df59fa.jpg"
                  }
              ]
          },
          {
              "id": 3328,
              "slug": "the-witcher-3-wild-hunt",
              "name": "The Witcher 3: Wild Hunt",
              "released": "2015-05-18",
              "background_image": "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg",
              "rating": 4.66,
              
              "added_by_status": {
                  "yet": 1079,
                  "owned": 11068,
                  "beaten": 4536,
                  "toplay": 745,
                  "dropped": 875,
                  "playing": 845
              },
              
              "short_screenshots": [
                  {
                      "id": -1,
                      "image": "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg"
                  },
                  {
                      "id": 30336,
                      "image": "https://media.rawg.io/media/screenshots/1ac/1ac19f31974314855ad7be266adeb500.jpg"
                  },
                  {
                      "id": 30337,
                      "image": "https://media.rawg.io/media/screenshots/6a0/6a08afca95261a2fe221ea9e01d28762.jpg"
                  },
                  {
                      "id": 30338,
                      "image": "https://media.rawg.io/media/screenshots/cdd/cdd31b6b4a687425a87b5ce231ac89d7.jpg"
                  },
                  {
                      "id": 30339,
                      "image": "https://media.rawg.io/media/screenshots/862/862397b153221a625922d3bb66337834.jpg"
                  },
                  {
                      "id": 30340,
                      "image": "https://media.rawg.io/media/screenshots/166/166787c442a45f52f4f230c33fd7d605.jpg"
                  },
                  {
                      "id": 30342,
                      "image": "https://media.rawg.io/media/screenshots/f63/f6373ee614046d81503d63f167181803.jpg"
                  }
              ]
          }
      ],
    }
    """
    
    static func makeGameResponse() -> GameResponse {
        let data = Data(GameResponseDummy.jsonData.utf8)
        return try! JSONDecoder().decode(GameResponse.self, from: data)
    }
}
