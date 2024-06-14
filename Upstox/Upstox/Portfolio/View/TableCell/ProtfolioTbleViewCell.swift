//
//  ProtfolioTbleViewCell.swift
//  Upstox
//
//  Created by Pushkar Dubey on 13/06/24.
//

import UIKit

class ProtfolioTbleViewCell: UITableViewCell {
    
    private let symbolLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let priceLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let performanceLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(symbolLbl)
        contentView.addSubview(priceLbl)
        contentView.addSubview(quantityLbl)
        contentView.addSubview(performanceLbl)
        
        NSLayoutConstraint.activate([
            symbolLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            symbolLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            priceLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            priceLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            quantityLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            quantityLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            performanceLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            performanceLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func setUpData(data: UserHoldinUIMOdel) {
        symbolLbl.text = data.symbol
        let priceLblStr = createAttributedString(number1: "LTP:", font1: UIFont.systemFont(ofSize: 10), color1: .gray500, number2: "₹" + data.latesTradePrice, font2: UIFont.systemFont(ofSize: 12), color2: .bodyText1)
        priceLbl.attributedText = priceLblStr
        let quantityLblStr = createAttributedString(number1: "NET QTY:", font1: UIFont.systemFont(ofSize: 10), color1: .gray500, number2: data.quantity, font2: UIFont.systemFont(ofSize: 12), color2: .bodyText1)
        quantityLbl.attributedText = quantityLblStr
        let rupeeSymbol = data.isProfit ? "₹" : "-₹"
        let performanceLblStr = createAttributedString(number1: "P&L:", font1: UIFont.systemFont(ofSize: 10), color1: .gray500, number2: rupeeSymbol + data.profitLoss, font2: UIFont.systemFont(ofSize: 12), color2: data.isProfit ? .success500 : .error500)
        performanceLbl.attributedText = performanceLblStr
    }
    
    func createAttributedString(number1: String, font1: UIFont, color1: UIColor, number2: String, font2: UIFont, color2: UIColor) -> NSAttributedString {
        let attributesNumber1: [NSAttributedString.Key: Any] = [
            .font: font1,
            .foregroundColor: color1
        ]
        
        let attributesNumber2: [NSAttributedString.Key: Any] = [
            .font: font2,
            .foregroundColor: color2
        ]
        
        let attributedNumber1 = NSAttributedString(string: number1, attributes: attributesNumber1)
        let attributedNumber2 = NSAttributedString(string: number2, attributes: attributesNumber2)
        
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(attributedNumber1)
        combinedAttributedString.append(NSAttributedString(string: " "))
        combinedAttributedString.append(attributedNumber2)
        
        return combinedAttributedString
    }
}

struct UserHoldinUIMOdel {
    let symbol: String
    let latesTradePrice: String
    let profitLoss: String
    let quantity: String
    let isProfit: Bool
}
