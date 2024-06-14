//
//  PortfolioService.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation

protocol PortfolioServiceDelegate: UserHoldingDelegate {
    
}

protocol UserHoldingDelegate {
    func getUserHoldingData(completion: @escaping(Result<Portfolio, NetworkError>) -> Void)
}

class PortfolioService: PortfolioServiceDelegate  {
    
    func getUserHoldingData(completion: @escaping(Result<Portfolio, NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") else {
            return completion(.failure(.BadURL))
        }
        NetworkManager().fetchRequest(type: Portfolio.self, url: url, completion: completion)
    }
}
