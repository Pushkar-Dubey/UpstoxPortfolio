//
//  BottomTbleViewCell.swift
//  Upstox
//
//  Created by Pushkar Dubey on 13/06/24.
//

import UIKit

class PerformanceTableViewCell: UITableViewCell {
    
    private let statusLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .bodyText2
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let amountLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray6
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(bgView)
        bgView.addSubview(statusLbl)
        bgView.addSubview(amountLbl)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            statusLbl.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            statusLbl.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            amountLbl.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            amountLbl.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupData(data: PerformanceUIModel) {
        statusLbl.text = data.title
        amountLbl.text = data.amonut
        amountLbl.textColor = data.amountTextColor
    }
}

struct PerformanceUIModel {
    let title: String
    let amonut: String
    let amountTextColor: UIColor
}
