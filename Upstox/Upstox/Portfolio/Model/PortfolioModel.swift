//
//  PortfolioModel.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation
import CoreData


// MARK: - Portfolio
struct Portfolio: Codable {
    var portfolioData: PortfolioData
    
    enum CodingKeys: String, CodingKey {
        case portfolioData = "data"
    }
}

// MARK: - PortfolioData
struct PortfolioData: Codable {
    var userHoldings: [UserHolding]
    
    enum CodingKeys: String, CodingKey {
        case userHoldings = "userHolding"
    }
}

struct UserHolding: Codable, CoreDataConvertible {
    let symbol: String
    let quantity: Int
    let lastTradedPrice: Double
    let averagePrice: Double
    let closingPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol, quantity
        case lastTradedPrice = "ltp"
        case averagePrice = "avgPrice"
        case closingPrice = "close"
    }

    // MARK: - CoreDataConvertible
    typealias Entity = UserHoldingEntity

    func toCoreDataEntity(context: NSManagedObjectContext) -> UserHoldingEntity {
        let entity = UserHoldingEntity(context: context)
        entity.symbol = symbol
        entity.quantity = Int32(quantity)
        entity.lastTradedPrice = lastTradedPrice
        entity.averagePrice = averagePrice
        entity.closingPrice = closingPrice
        return entity
    }

    init(entity: UserHoldingEntity) {
        self.symbol = entity.symbol ?? String()
        self.quantity = Int(entity.quantity)
        self.lastTradedPrice = entity.lastTradedPrice
        self.averagePrice = entity.averagePrice
        self.closingPrice = entity.closingPrice
    }
    
    init(symbol: String, quantity: Int, lastTradedPrice: Double, averagePrice: Double, closingPrice: Double) {
        self.symbol = symbol
        self.quantity = quantity
        self.lastTradedPrice = lastTradedPrice
        self.averagePrice = averagePrice
        self.closingPrice = closingPrice
    }
}


struct PortfolioCalculations {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double
    let percentagePNL: Double
}
