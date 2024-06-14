//
//  PortfolioViewController.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import UIKit

final class PortfolioViewController: UIViewController {
    
    // MARK: - Views
    var mainTableView: UITableView!
    var bottomTableView: UITableView!
    var collectionView: UICollectionView!
    let separatorView = UIView()
    let collectionSepratorView = UIView()
    let customNavView = CustomNavView()
    let bottomContainerView = UIView()
    let footerView = UIView()
    var holdingUIData: [UserHoldinUIMOdel] = []
    var performanceUIModel: [PerformanceUIModel] = []
    let totalProfitLossLbl = UILabel()
    let footerArrowImageView =  UIImageView()
    let totalProfitLossAmountLbl = UILabel()
    
    // MARK: - Properties
    
    let mainCellIdentifier = "ProtfolioTbleViewCell"
    let performaceCellIndentifier = "PerformanceTableViewCell."
    var tabs = ["POSITION", "HOLDINGS"]
    var isExpanded = false
    var bottomContainerViewHeightConstraint: NSLayoutConstraint!
    let maxContainerHeight: CGFloat = UIScreen.main.bounds.height * 2 / 3
    var portFolioPerformanceRows = 3
   
    var currentSelectedTab = 1
    
       // MARK: - ViewModel
    var viewModel: PortfolioViewModel
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    
    init(viewModel: PortfolioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = PortfolioViewModel()
        super.init(coder: coder)
    }
  
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Setup Methods
    
    private func initialSetup() {
        setupCustomNavigationView()
        setupCollectionView()
        setupCollectionSepratorView()
        setupBottomContainerView()
        setupMainTableView()
        setupBottomTableView()
        setupFooterView()
        fetchUserHoldings()
    }
    
    func updateData() {
        prepareHoldingData()
        preparePerformanceData()
        setupFooterViewData()
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            mainTableView.reloadData()
            bottomTableView.reloadData()
        }
    }
    
    func prepareHoldingData() {
        let holdings = viewModel.userHoldings
        holdingUIData.removeAll()
        holdings?.forEach { holding in
            let profitOrLoss = ((holding.lastTradedPrice - holding.averagePrice) * Double(holding.quantity))
            let isProft = profitOrLoss >= 0
            let data = UserHoldinUIMOdel(symbol: "\(holding.symbol)", latesTradePrice: "\(holding.lastTradedPrice)", profitLoss: String(format: "%.2f", abs(profitOrLoss)), quantity: "\(holding.quantity)", isProfit: isProft)
            holdingUIData.append(data)
        }
    }
    
    func preparePerformanceData() {
        performanceUIModel.removeAll()
        
       let portFolioCalculation = viewModel.portFolioCalculation
        let currentData = PerformanceUIModel(title: "Current value*", amonut: "₹" + String(format: "%.2f", portFolioCalculation?.currentValue ?? 0), amountTextColor: UIColor.bodyText1)
       performanceUIModel.append(currentData)
        
        let totalInvestment = PerformanceUIModel(title: "Total investment*", amonut: "₹" + String(format: "%.2f", portFolioCalculation?.totalInvestment ?? 0), amountTextColor: UIColor.bodyText1)
       performanceUIModel.append(totalInvestment)
        
        let todayTextColor: UIColor = (portFolioCalculation?.todaysPNL ?? 0) >= 0 ? UIColor.success500 : UIColor.error500
        let todayRupeeSymbol: String = (portFolioCalculation?.todaysPNL ?? 0) >= 0 ? "₹" : "-₹"
        let todaysProfitLoss = PerformanceUIModel(title: "Today's Profit & Loss*", amonut: todayRupeeSymbol + String(format: "%.2f", abs(portFolioCalculation?.todaysPNL ?? 0)), amountTextColor: todayTextColor)
       performanceUIModel.append(todaysProfitLoss)
        
        let textColor: UIColor = (portFolioCalculation?.totalPNL ?? 0) >= 0 ? UIColor.success500 : UIColor.error500
        let totalRupeeSymbol: String = (portFolioCalculation?.totalPNL ?? 0) >= 0 ? "₹" : "-₹"
        let percentagePNLStr: String = "(\(String(format: "%.2f", abs(portFolioCalculation?.percentagePNL ?? 0)))%)"
        
        let totalpNL = PerformanceUIModel(title: "Profit & Loss*", amonut: totalRupeeSymbol + String(format: "%.2f", abs(portFolioCalculation?.totalPNL ?? 0)) + percentagePNLStr, amountTextColor: textColor)
       performanceUIModel.append(totalpNL)
        
    }
    
    func setupFooterViewData() {
        totalProfitLossLbl.text = performanceUIModel.last?.title
        totalProfitLossAmountLbl.text = performanceUIModel.last?.amonut
        totalProfitLossAmountLbl.textColor = performanceUIModel.last?.amountTextColor
    }
    
    private func setupCustomNavigationView() {
        customNavView.translatesAutoresizingMaskIntoConstraints = false
        customNavView.backgroundColor = .primary500
        view.addSubview(customNavView)
        
        NSLayoutConstraint.activate([
            customNavView.topAnchor.constraint(equalTo: view.topAnchor),
            customNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .white
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "TabCollectionViewCell")
            
            view.addSubview(collectionView)
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: customNavView.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    
    func setupCollectionSepratorView() {
        collectionSepratorView.translatesAutoresizingMaskIntoConstraints = false
        collectionSepratorView.backgroundColor = .gray100
        self.view.addSubview(collectionSepratorView)
        
        NSLayoutConstraint.activate([
            collectionSepratorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            collectionSepratorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 2),
            collectionSepratorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            collectionSepratorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
        
    
    private func setupMainTableView() {
        mainTableView = UITableView(frame: .zero, style: .plain)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(ProtfolioTbleViewCell.self, forCellReuseIdentifier: mainCellIdentifier)
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: collectionSepratorView.bottomAnchor, constant: 2),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor,constant: -5)
        ])
    }
    
    private func setupBottomContainerView() {
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = .gray6
        bottomContainerView.addBorderAtTopwith(radius: 12, borderColor: .gray100)
        view.addSubview(bottomContainerView)
        
        bottomContainerViewHeightConstraint = bottomContainerView.heightAnchor.constraint(equalToConstant: 52)
        
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainerViewHeightConstraint
        ])
    }
    
    private func setupBottomTableView() {
        bottomTableView = UITableView(frame: .zero, style: .plain)
        bottomTableView.translatesAutoresizingMaskIntoConstraints = false
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.separatorStyle = .none
        bottomTableView.backgroundColor = .gray6
        bottomTableView.register(PerformanceTableViewCell.self, forCellReuseIdentifier: performaceCellIndentifier)
        bottomContainerView.addSubview(bottomTableView)
        
        NSLayoutConstraint.activate([
            bottomTableView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 12),
            bottomTableView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            bottomTableView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            bottomTableView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor)
        ])
    }
    
    private func setupFooterView() {
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .gray6
        bottomContainerView.addSubview(footerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFooterTap))
        footerView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray300
        footerView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            separatorView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
            separatorView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
        
        separatorView.isHidden = true
        
       
        totalProfitLossLbl.translatesAutoresizingMaskIntoConstraints = false
        totalProfitLossLbl.textColor = .bodyText2
        totalProfitLossLbl.font = UIFont.systemFont(ofSize: 14)
        footerView.addSubview(totalProfitLossLbl)
        
        
       
        totalProfitLossAmountLbl.translatesAutoresizingMaskIntoConstraints = false
        totalProfitLossAmountLbl.font = UIFont.systemFont(ofSize: 14)
        footerView.addSubview(totalProfitLossAmountLbl)
        
        NSLayoutConstraint.activate([
            totalProfitLossLbl.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            totalProfitLossLbl.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            totalProfitLossAmountLbl.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            totalProfitLossAmountLbl.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        footerArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(footerArrowImageView)
        footerArrowImageView.image = UIImage.upArrow
        footerArrowImageView.tintColor = .gray500
        
       
        
        NSLayoutConstraint.activate([
            footerArrowImageView.leadingAnchor.constraint(equalTo: totalProfitLossLbl.trailingAnchor, constant: 4),
            footerArrowImageView.centerYAnchor.constraint(equalTo: totalProfitLossLbl.centerYAnchor),
            footerArrowImageView.heightAnchor.constraint(equalToConstant: 20),
            footerArrowImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    // MARK: - Action
    
    @objc private func handleFooterTap() {
        isExpanded.toggle()
        let maxH = 40 * 3 > maxContainerHeight ? maxContainerHeight : 40 * 3
        bottomTableView.isScrollEnabled = 40 * 3 > maxContainerHeight
        separatorView.isHidden = !isExpanded
        footerArrowImageView.image = isExpanded ? UIImage.downArrow : UIImage.upArrow
        let newHeight = isExpanded ? maxH + 52 : 52
        bottomContainerViewHeightConstraint.constant = newHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        bottomTableView.reloadData()
    }
}
