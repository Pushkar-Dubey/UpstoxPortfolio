//
//  MockPortfolioServices.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation

class MockPortfolioService: PortfolioServiceDelegate {
    var mockResult: Result<Portfolio, NetworkError>?

    func getUserHoldingData(completion: @escaping (Result<Portfolio, NetworkError>) -> Void) {
        if let mockResult = mockResult {
            completion(mockResult)
        } else {
            completion(.failure(.BadURL))
        }
    }
}
