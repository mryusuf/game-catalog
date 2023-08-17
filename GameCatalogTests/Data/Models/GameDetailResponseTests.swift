//
//  GameDetailResponseTests.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 17/08/23.
//

@testable import GameCatalog
import XCTest

final class GameDetailResponseTests: XCTestCase {
    var sut: GameDetailResponse!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = GameDetailResponseDummy.makeGameDetailResponse()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testGameDetailResponse() throws {
        XCTAssertTrue((sut as Any) is Decodable)
        XCTAssertEqual(sut.id, 3498)
        XCTAssertEqual(sut.name, "Grand Theft Auto V")
    }

}
