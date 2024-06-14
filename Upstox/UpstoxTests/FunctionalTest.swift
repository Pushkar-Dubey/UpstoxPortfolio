//
//  FunctionalTest.swift
//  UpstoxTests
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation
import XCTest
@testable import Upstox

class AddFunctionTests: XCTestCase {
    
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
    
    func testportFolioCalculation() {
        let mockUserHoldings = [
            UserHolding(symbol: "AAPL", quantity: 10, lastTradedPrice: 150.0, averagePrice: 145.0, closingPrice: 152.0)
        ]
        let mockPortfolioData = PortfolioData(userHoldings: mockUserHoldings)
        let mockPortfolio = Portfolio(portfolioData: mockPortfolioData)
        mockServiceHandler.mockResult = .success(mockPortfolio)
        mockDatabaseManager.mockObjects = mockUserHoldings

        let expectation = XCTestExpectation(description: "Portfolio calculation correct")

        viewModel.didFinishFetchUserHolding = {
            let result = self.viewModel.portFolioCalculation
            XCTAssertEqual(result?.todaysPNL, 20.0)
            XCTAssertEqual(result?.currentValue, 1500.0)
            XCTAssertEqual(result?.totalPNL, 50.0)
            XCTAssertEqual(result?.totalInvestment, 1450.0)
            
            expectation.fulfill()
        }
        viewModel.fetchStockHoldingData()
        wait(for: [expectation], timeout: 10.0)
    }
}
