//
//  HomeForVisitorVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency

final class HomeForVisitorVC: UIViewController, HomeForVisitorViewControllable {

    // MARK: - Properties

    public let viewModel: HomeForVisitorViewModel
    private var cancelBag = CancelBag()
    private var cellTapped = PassthroughSubject<HomeForVisitorItem, Never>()
    
    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar().hideNoticeButton()
    private var dataSource: UICollectionViewDiffableDataSource<HomeForVisitorSectionLayoutKind, HomeForVisitorItem>! = nil
    var collectionView: UICollectionView! = nil
    
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
        configureHierarchy()
        setUI()
        setLayout()
        setDelegate()
        setDataSource()
        bindViewModels()
    }
}

// MARK: - UI & Layout

extension HomeForVisitorVC {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
    }
    
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
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
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
    }
    
    private func setDataSource() {
        let dashBoardRegistration = createDashBoardCellRegistration()
        let mainProductRegistration = createProductCellRegistration()
        let appServiceRegistration = createAppServiceCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<HomeForVisitorSectionLayoutKind, HomeForVisitorItem> (
            collectionView: collectionView) { (collectionView, indexPath, item) in
                switch item {
                case .dashBoard(let dashBoard):
                    return collectionView.dequeueConfiguredReusableCell(using: dashBoardRegistration,
                                                                        for: indexPath, item: dashBoard)
                case .productService(let productService):
                    return collectionView.dequeueConfiguredReusableCell(using: mainProductRegistration,
                                                                        for: indexPath, item: productService)
                case .appService(let appService):
                    return collectionView.dequeueConfiguredReusableCell(using: appServiceRegistration,
                                                                        for: indexPath, item: appService)
                }
            }
        
        configureSupplementaryView()
    }
    
    private func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
            
            return UICollectionReusableView()
        }
    }
    
    private func bindViewModels() {
        let input = HomeForVisitorViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            cellTapped: cellTapped.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.appService
            .withUnretained(self)
            .sink { owner, appService in
                owner.applySnapshot(with: appService)
            }.store(in: cancelBag)
        
        output.isLoading
            .withUnretained(self)
            .sink { owner, isLoading in
                isLoading ? owner.showLoading() : owner.stopLoading()
            }.store(in: cancelBag)
    }
    
    private func applySnapshot(with appService: [HomePresentationModel.AppService]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeForVisitorSectionLayoutKind, HomeForVisitorItem>()
        
        snapshot.appendSections(HomeForVisitorSectionLayoutKind.allCases)
        
        snapshot.appendItems([.dashBoard(HomePresentationModel.DashBoard())], toSection: .dashBoard)
        snapshot.appendItems(self.viewModel.productServiceList.map { .productService($0) }, toSection: .mainProduct)
        snapshot.appendItems(appService.map { .appService($0) }, toSection: .appService)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeForVisitorVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            switch selectedItem {
            case .productService(let model):
                self.cellTapped.send(.productService(model))
            case .appService(let model):
                self.cellTapped.send(.appService(model))
            default: return
            }
        }
    }
}
