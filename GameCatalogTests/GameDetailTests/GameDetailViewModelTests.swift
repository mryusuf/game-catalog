//
//  GameDetailViewModelTests.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 16/08/23.
//

import XCTest
@testable import GameCatalog

final class GameDetailViewModelTests: XCTestCase {

    var sut: GameDetailViewModel!
    var dummyData: GameDetailResponse!
    
    override func setUpWithError() throws {
        sut = GameDetailViewModelMock()
        dummyData = GameDetailResponseDummy.makeGameDetailResponse()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchGameDetail() async throws {
        let id = dummyData.id
        await sut.fetchGameDetail()
        
        XCTAssertEqual(sut.gameDetail?.id, id)
    }

}
