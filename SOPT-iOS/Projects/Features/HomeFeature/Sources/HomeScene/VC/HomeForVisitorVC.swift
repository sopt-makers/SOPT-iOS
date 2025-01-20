//
//  HomeForVisitorVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import BaseFeatureDependency

final class HomeForVisitorVC: UIViewController, HomeForVisitorViewControllable {

    // MARK: - Properties

    public let viewModel: HomeForVisitorViewModel
    
    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar().hideNoticeButton()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    ).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initialization
    
    public init(viewModel: HomeForVisitorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
    }
}

// MARK: - UI & Layout

extension HomeForVisitorVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        view.addSubviews(
            naviBar,
            collectionView
        )
        
        naviBar.snp.makeConstraints { make in
          make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension HomeForVisitorVC {
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        /// Header
        self.collectionView.register(HomeDefaultHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: HomeDefaultHeaderView.className)
        
        /// Cell
        self.collectionView.register(DashBoardCardCVC.self,
                                     forCellWithReuseIdentifier: DashBoardCardCVC.className)
        self.collectionView.register(MainProductCardCVC.self,
                                     forCellWithReuseIdentifier: MainProductCardCVC.className)
        self.collectionView.register(AppServiceCardCVC.self,
                                     forCellWithReuseIdentifier: AppServiceCardCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeForVisitorVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension HomeForVisitorVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeForVisitorSectionLayoutKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: indexPath.section) else { return UICollectionReusableView() }
        guard let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: HomeDefaultHeaderView.className,
                                              for: indexPath) as? HomeDefaultHeaderView else { return UICollectionReusableView() }
        headerView.setDataForVisitor(sectionKind: sectionKind)
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: section) else { return 0 }
        
        switch sectionKind {
        case .dashBoard: return 1
        case .mainProduct: return viewModel.productInfoList.count
        case .appService: return viewModel.appServiceInfoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch sectionKind {
        case .dashBoard:
            /// 대시보드 카드 셀
            guard let dashBoardCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: DashBoardCardCVC.className,
                                     for: indexPath) as? DashBoardCardCVC else { return UICollectionViewCell() }
            dashBoardCardCell.configureCell(userType: .visitor, description: "")
            
            return dashBoardCardCell
            
        case .mainProduct:
            /// 프로덕트 카드 셀
            let productIndex = indexPath.item
            guard let product = viewModel.productInfoList[safe: productIndex] else { return UICollectionViewCell() }
            guard let productCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: MainProductCardCVC.className,
                                     for: indexPath) as? MainProductCardCVC else { return UICollectionViewCell() }
            productCardCell.configureCell(title: product.name,
                                          image: product.image)
            
            return productCardCell
            
        case .appService:
            /// 앱 서비스 카드 셀
            let appServiceIndex = indexPath.item
            guard let appService = viewModel.appServiceInfoList[safe: appServiceIndex] else { return UICollectionViewCell() }
            guard let appServiceCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: AppServiceCardCVC.className,
                                     for: indexPath) as? AppServiceCardCVC else { return UICollectionViewCell() }
            appServiceCardCell.configureCell(model: HomeAppServicesModel(
                serviceName: "",
                displayAlarmBadge: false,
                alarmBadge: "",
                iconURL: "",
                deepLink: ""
            ))
            
            return appServiceCardCell
        }
    }
}
