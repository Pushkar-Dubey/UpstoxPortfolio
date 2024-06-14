//
//  NavView.swift
//  Upstox
//
//  Created by Pushkar Dubey on 13/06/24.
//

import UIKit

class CustomNavView: UIView {
    
    let userImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.user
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Portfolio"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .primaryLight
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.primary500
        
        self.addSubview(userImgView)
        self.addSubview(titleLbl)
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            userImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            userImgView.widthAnchor.constraint(equalToConstant: 20),
            userImgView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: userImgView.trailingAnchor, constant: 10),
            titleLbl.centerYAnchor.constraint(equalTo: userImgView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20), // Adjust right padding as needed
            stackView.centerYAnchor.constraint(equalTo: userImgView.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 20),
            stackView.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 15),
            stackView.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        let internetBgView = UIView()
        internetBgView.backgroundColor = .primary500
        internetBgView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(internetBgView)
        
        let serachBgView = UIView()
        serachBgView.backgroundColor = .primary500
        serachBgView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(serachBgView)
        
        let internetImgView = UIImageView()
        internetImgView.image = UIImage.arrows
        internetImgView.translatesAutoresizingMaskIntoConstraints = false
        internetImgView.tintColor = .white
        internetBgView.addSubview(internetImgView)
        
        NSLayoutConstraint.activate([
            internetImgView.centerXAnchor.constraint(equalTo: internetBgView.centerXAnchor),
            internetImgView.centerYAnchor.constraint(equalTo: internetBgView.centerYAnchor),
            internetImgView.widthAnchor.constraint(equalToConstant: 20),
            internetImgView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let searchImageView = UIImageView()
        searchImageView.image = UIImage.search
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.tintColor = .white
        serachBgView.addSubview(searchImageView)
        
        NSLayoutConstraint.activate([
            searchImageView.centerXAnchor.constraint(equalTo: serachBgView.centerXAnchor),
            searchImageView.centerYAnchor.constraint(equalTo: serachBgView.centerYAnchor),
            searchImageView.widthAnchor.constraint(equalToConstant: 20),
            searchImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
