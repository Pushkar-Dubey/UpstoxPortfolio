//
//  PortfolioViewController+UITableView.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation
import UIKit

// MARK: - UITableViewDataSource Methods

enum TableViewType {
    case main
    case bottom
}

extension PortfolioViewController: UITableViewDataSource {
    
    private func tableViewType(for tableView: UITableView) -> TableViewType {
            if tableView == mainTableView {
                return .main
            } else {
                return .bottom
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewType(for: tableView) {
        case .main:
            return viewModel.numberOfRows
        case .bottom:
            return isExpanded ? performanceUIModel.count - 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewType(for: tableView) {
        case .main:
            guard let cell = dequeueReusableCell(for: tableView, identifier: mainCellIdentifier, indexPath: indexPath) as? ProtfolioTbleViewCell else {return UITableViewCell()}
            cell.setUpData(data: holdingUIData[indexPath.row])
            return cell
            
        case .bottom:
            guard let cell = dequeueReusableCell(for: tableView, identifier: performaceCellIndentifier, indexPath: indexPath) as? PerformanceTableViewCell else {return UITableViewCell()}
            cell.setupData(data: performanceUIModel[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension PortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewType(for: tableView) {
        case .main:
           return 60
            
        case .bottom:
           return 40
        }
    }
    
    private func dequeueReusableCell(for tableView: UITableView, identifier: String, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
