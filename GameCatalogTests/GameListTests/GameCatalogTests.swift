//
//  GameCatalogTests.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 14/08/23.
//

import XCTest
@testable import GameCatalog

final class GameCatalogTests: XCTestCase {

    var sut: GameListViewModel!
    var dummyData: GameResponse!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = GameListViewModelMock()
        dummyData = GameResponseDummy.makeGameResponse()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchGameList() async throws {
        let gamesCount = dummyData.results.count
        
        await sut.fetchGameList()
        
        print(sut.gameList)
        
        XCTAssertEqual(sut.gameList.count, gamesCount)
    }

    func testFetchNextGameList() async throws {
        let gamesCount = dummyData.results.count * 2
        
        await sut.fetchNextGameList()
        
        print(sut.gameList)
        
        XCTAssertEqual(sut.gameList.count, gamesCount)
    }

    func testFetchSearchGameList() async throws {
        let gamesCount = dummyData.results.count
        
        await sut.fetchSearchGame(query: "query")
        
        print(sut.gameList)
        
        XCTAssertEqual(sut.gameList.count, gamesCount)
    }

    func testFetchNextSearchGameList() async throws {
        let gamesCount = dummyData.results.count * 2
        
        await sut.fetchNextSearchGame(query: "query")
        
        print(sut.gameList)
        
        XCTAssertEqual(sut.gameList.count, gamesCount)
    }

}
