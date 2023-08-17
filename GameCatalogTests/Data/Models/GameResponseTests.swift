//
//  GameResponseTests.swift
//  GameCatalogTests
//
//  Created by Indra Permana on 17/08/23.
//

@testable import GameCatalog
import XCTest

final class GameResponseTests: XCTestCase {
    var sut: GameResponse!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = GameResponseDummy.makeGameResponse()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testGameResponse() throws {
        XCTAssertTrue((sut as Any) is Decodable)
        XCTAssertEqual(sut.count, 852582)
        XCTAssertEqual(sut.results.count, 2)

        let game = sut.results.first

        XCTAssertEqual(game?.id, 3498)
        XCTAssertEqual(game?.name, "Grand Theft Auto V")
        
    }

}
