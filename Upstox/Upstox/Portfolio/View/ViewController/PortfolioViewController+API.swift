//
//  PortfolioViewController+API.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation

extension PortfolioViewController {
    func fetchUserHoldings() {
        viewModel.didFinishFetchUserHolding = { [weak self] in
            guard let self else {return}
            self.updateData()
        }
        viewModel.fetchStockHoldingData()
    }
}
