//
//  TabCollectionViewCell.swift
//  Upstox
//
//  Created by Pushkar Dubey on 13/06/24.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .heading
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray400
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        contentView.addSubview(title)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: title.bottomAnchor),
            separatorView.centerXAnchor.constraint(equalTo: title.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 100),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(withText text: String, isSelected: Bool) {
        title.text = text
        title.font = isSelected ? UIFont.boldSystemFont(ofSize: 12) : UIFont.systemFont(ofSize: 12)
        separatorView.isHidden = !isSelected
    }
}
