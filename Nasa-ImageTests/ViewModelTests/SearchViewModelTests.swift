//
//  Nasa_ImageTests.swift
//  Nasa-ImageTests
//
//  Created by William on 6/21/23.
//

import XCTest

final class SearchImageViewModelTests: XCTestCase {

    func testSearch() async throws {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageProvider())
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "moon"
        await viewModel.searchNasaImages()
        
        XCTAssertEqual(viewModel.nasaListItems.first?.title, MockResult.nasaListItem.title)
        XCTAssertEqual(viewModel.loadingState, .loaded)
        XCTAssertFalse(viewModel.isError)
    }
    
    func testSearchNoResult() async throws {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageProviderEmpty())
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "123495830gyfh"
        await viewModel.searchNasaImages()
        
        XCTAssertTrue(viewModel.nasaListItems.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .noResult(query: "123495830gyfh"))
        XCTAssertFalse(viewModel.isError)
    }
    
    func testClear() async {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageProvider())
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "moon"
        await viewModel.searchNasaImages()
        
        XCTAssertTrue(!viewModel.nasaListItems.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .loaded)
        viewModel.clearResults()
        XCTAssertEqual(viewModel.loadingState, .initial)
        XCTAssertTrue(viewModel.nasaListItems.isEmpty)
        XCTAssertFalse(viewModel.isError)
    }
    
    func testSearchCancelTask() async {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageCancelled())
        viewModel.nasaListItems = [MockResult.nasaListItem]
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "mars"
        await viewModel.searchNasaImages()
        
        XCTAssertTrue(viewModel.nasaListItems.isEmpty)
        XCTAssertFalse(viewModel.isError)
    }
    
    func testSearchInvalidURL() async {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageInvalidURL())
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "moon"
        await viewModel.searchNasaImages()
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        XCTAssertTrue(viewModel.isError)
    }
    
    func testSearchHTTPError() async {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageHTTPError())
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "moon"
        await viewModel.searchNasaImages()
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        XCTAssertTrue(viewModel.isError)
    }
    
    func testSearchDecodingError() async {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageDecodingError())
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        viewModel.searchQuery = "moon"
        await viewModel.searchNasaImages()
        
        XCTAssertEqual(viewModel.loadingState, .initial)
        XCTAssertTrue(viewModel.isError)
    }
    
    func testSearchErrorWithItemsLoaded() async {
        let viewModel = SearchImageViewModel(nasaImageProvider: MockNasaImageInvalidURL())
        viewModel.nasaListItems = [MockResult.nasaListItem]
        viewModel.loadingState = .loaded
        
        viewModel.searchQuery = "star"
        await viewModel.searchNasaImages()
        
        XCTAssertEqual(viewModel.loadingState, .loaded)
        XCTAssertEqual(viewModel.nasaListItems.first?.title, MockResult.nasaListItem.title)
        XCTAssertTrue(viewModel.isError)
    }
}
