//
//  APIAndDataBaseTest.swift
//  UpstoxTests
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation

import XCTest
@testable import Upstox


class PortfolioViewModelTests: XCTestCase {

    var viewModel: PortfolioViewModel!
    var mockServiceHandler: MockPortfolioService!
    var mockDatabaseManager: MockDatabaseManager<UserHolding>!

    override func setUp() {
        super.setUp()
        mockServiceHandler = MockPortfolioService()
        mockDatabaseManager = MockDatabaseManager<UserHolding>(entityName: "Userholding")
        viewModel = PortfolioViewModel(serviceHandler: mockServiceHandler, userHoldingManager: mockDatabaseManager)
    }

    override func tearDown() {
        viewModel = nil
        mockServiceHandler = nil
        mockDatabaseManager = nil
        super.tearDown()
    }

    func testFetchStockHoldingData_Success() {
        let mockUserHoldings = [
            UserHolding(symbol: "AAPL", quantity: 10, lastTradedPrice: 150.0, averagePrice: 145.0, closingPrice: 152.0)
        ]
        let mockPortfolioData = PortfolioData(userHoldings: mockUserHoldings)
        let mockPortfolio = Portfolio(portfolioData: mockPortfolioData)
        mockServiceHandler.mockResult = .success(mockPortfolio)
        mockDatabaseManager.mockObjects = mockUserHoldings

        let expectation = XCTestExpectation(description: "Fetch user holdings")

        viewModel.fetchStockHoldingData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.userHoldings?.count, 1)
            XCTAssertEqual(self.viewModel.userHoldings?.first?.symbol, "AAPL")
            XCTAssertEqual(self.mockDatabaseManager.mockObjects.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchStockHoldingData_Failure() {
        mockServiceHandler.mockResult = .failure(.BadURL)
        viewModel.fetchStockHoldingData()
        XCTAssertNil(viewModel.userHoldings)
    }
}
