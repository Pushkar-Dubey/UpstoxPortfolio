//
//  PortfolioViewModel.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation

class PortfolioViewModel {
    let serviceHandler: PortfolioServiceDelegate
    let userHoldingManager: DatabaseManager<UserHolding>
    
    init(serviceHandler: PortfolioServiceDelegate = PortfolioService(),
         userHoldingManager: DatabaseManager<UserHolding> = DatabaseManager<UserHolding>(entityName: "Userholding")) {
        self.serviceHandler = serviceHandler
        self.userHoldingManager = userHoldingManager
    }
    

    var didFinishFetchUserHolding: (() -> Void)?
    
    var numberOfRows: Int {
        userHoldings?.count ?? 0
    }
    
    var userHoldings: [UserHolding]? {
        didSet {
            self.didFinishFetchUserHolding?()
        }
    }
    
    var portFolioCalculation: PortfolioCalculations? {
        let holdings = userHoldings ?? []
        return  calculatePortfolioMetrics(holdings: holdings)
    }
    
    var isConnected: Bool {
        NetworkMonitor.shared.isConnected
    }
      
    
    func calculatePortfolioMetrics(holdings: [UserHolding]) -> PortfolioCalculations {
        var currentValue: Double = 0
        var totalInvestment: Double = 0
        var totalPNL: Double = 0
        var todaysPNL: Double = 0
        
        holdings.forEach { holding in
            let holdingCurrentValue = holding.lastTradedPrice * Double(holding.quantity)
            let holdingInvestment = holding.averagePrice * Double(holding.quantity)
            let holdingPNL = holdingCurrentValue - holdingInvestment
            let holdingTodaysPNL = (holding.closingPrice - holding.lastTradedPrice) * Double(holding.quantity)
            
            currentValue += holdingCurrentValue
            totalInvestment += holdingInvestment
            totalPNL += holdingPNL
            todaysPNL += holdingTodaysPNL
        }
        
        let percentagePNL = (totalInvestment != 0) ? (totalPNL / totalInvestment) * 100 : 0.0
        
        return PortfolioCalculations(currentValue: currentValue,
                                     totalInvestment: totalInvestment,
                                     totalPNL: totalPNL,
                                     todaysPNL: todaysPNL, percentagePNL: percentagePNL)
    }

    func fetchStockHoldingData() {
        if isConnected {
            serviceHandler.getUserHoldingData() { [weak self] result in
                guard let self else {return}
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.userHoldings = data.portfolioData.userHoldings
                        let userHoldings: [UserHolding] = self.userHoldings ?? []
                        // Save to Core Data
                        self.userHoldingManager.deleteAll()
                        self.userHoldingManager.save(objects: userHoldings)
                    case .failure(let error):
                        print(error)
                    }
                }
                
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                let fetchedUserHoldings = self.userHoldingManager.fetch()
                self.userHoldings = fetchedUserHoldings
            }
        }
        
    }

}

