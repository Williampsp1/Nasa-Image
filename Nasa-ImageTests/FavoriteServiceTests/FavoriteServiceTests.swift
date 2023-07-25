//
//  FavoriteServiceTests.swift
//  Nasa-ImageTests
//
//  Created by William on 7/1/23.
//

import XCTest

final class FavoriteServiceTests: XCTestCase {

    func testAddFavorite() {
        let favoriteService = FavoritesService()
        XCTAssert(favoriteService.favorites.isEmpty)
        favoriteService.addFavorite(item: MockResult.nasaListItem)
        XCTAssertEqual(favoriteService.favorites, [MockResult.nasaListItem])
    }
    
    func testRemoveFavorite() {
        let favoriteService = FavoritesService()
        XCTAssert(favoriteService.favorites.isEmpty)
        favoriteService.addFavorite(item: MockResult.nasaListItem)
        XCTAssertEqual(favoriteService.favorites, [MockResult.nasaListItem])
        favoriteService.addFavorite(item: MockResult.nasaListItem)
        XCTAssert(favoriteService.favorites.isEmpty)
    }
    
    func testContains() {
        let favoriteService = FavoritesService()
        XCTAssert(favoriteService.favorites.isEmpty)
        favoriteService.addFavorite(item: MockResult.nasaListItem)
        XCTAssertTrue(favoriteService.contains(item: MockResult.nasaListItem))
    }
}
