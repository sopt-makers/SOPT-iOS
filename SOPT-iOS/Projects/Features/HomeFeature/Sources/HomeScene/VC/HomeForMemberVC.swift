//
//  HomeForMemberVC.swift
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

final class HomeForMemberVC: UIViewController, HomeForMemberViewControllable {
    
    // MARK: - Properties
    
    public let viewModel: HomeForMemberViewModel
    private(set) var cancelBag = CancelBag()
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    private var cellTapped = PassthroughSubject<HomeForMemberItem, Never>()
    private(set) var attendanceButtonTapped = PassthroughSubject<Void, Never>()
    
    private var isFirstAppear = true
    
    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar()
    private var dataSource: UICollectionViewDiffableDataSource<HomeForMemberSectionLayoutKind, HomeForMemberItem>! = nil
    var collectionView: UICollectionView! = nil
    
    // MARK: - Initialization
    
    public init(viewModel: HomeForMemberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureUI()
        configureLayout()
        configureDelegate()
        configureDataSource()
        bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppear.send()
    }
}

// MARK: - UI & Layout

extension HomeForMemberVC {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
    }
    
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func configureLayout() {
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

extension HomeForMemberVC {
    private func configureDelegate() {
        self.collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let dashBoardRegistration = createDashBoardCellRegistration()
        let calendarRegistration = createCalendarCellRegistration()
        let mainProductRegistration = createProductCellRegistration()
        let appServiceRegistration = createAppServiceCellRegistration()
        
        // TODO: 이후 스프린트에서 순차 배포
//        let insightRegistration = createInsightCellRegistration()
//        let groupRegistration  = createGroupCellRegistration()
//        let coffeeChatRegistration = createCoffeeChatCellRegistration()
//        let announcementRegistration = createAnnouncementCellRegistration()
//        let socialLinkRegistration = createSocialLinkCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<HomeForMemberSectionLayoutKind, HomeForMemberItem> (
            collectionView: collectionView) { (collectionView, indexPath, item) in
                switch item {
                case .dashBoard(let dashBoard):
                    return collectionView.dequeueConfiguredReusableCell(using: dashBoardRegistration,
                                                                        for: indexPath, item: dashBoard)
                case .recentSchedule(let schedule):
                    return collectionView.dequeueConfiguredReusableCell(using: calendarRegistration,
                                                                        for: indexPath, item: schedule)
                case .productService(let productService):
                    return collectionView.dequeueConfiguredReusableCell(using: mainProductRegistration,
                                                                        for: indexPath, item: productService)
                case .appService(let appService):
                    return collectionView.dequeueConfiguredReusableCell(using: appServiceRegistration,
                                                                        for: indexPath, item: appService)
                // TODO: 이후 스프린트에서 순차 배포
                default: return UICollectionViewCell()
//                case .insightPost(let insight):
//                    return collectionView.dequeueConfiguredReusableCell(using: insightRegistration,
//                                                                        for: indexPath, item: insight)
//                case .groupPost(let group):
//                    return collectionView.dequeueConfiguredReusableCell(using: groupRegistration,
//                                                                        for: indexPath, item: group)
//                case .coffeeChat(let coffeeChat):
//                    return collectionView.dequeueConfiguredReusableCell(using: coffeeChatRegistration,
//                                                                        for: indexPath, item: coffeeChat)
//                case .announcement(let announcement):
//                    return collectionView.dequeueConfiguredReusableCell(using: announcementRegistration,
//                                                                        for: indexPath, item: announcement)
//                case .socialLink(let socialLink):
//                    return collectionView.dequeueConfiguredReusableCell(using: socialLinkRegistration,
//                                                                        for: indexPath, item: socialLink)
                }
            }
        
        configureSupplementaryView()
    }
    
    private func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        // TODO: 이후 스프린트에서 순차 배포
//        let footerRegistration = createFooterRegistration()
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
            
            // TODO: 이후 스프린트에서 순차 배포
//            if kind == UICollectionView.elementKindSectionFooter {
//                return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
//            }
            
            return UICollectionReusableView()
        }
    }
    
    private func bindViewModels() {
        let noticeButtonTapped = naviBar.noticeButtonTap
            .mapVoid()
            .asDriver()
        
        let settingButtonTapped = naviBar.settingButtonTap
            .mapVoid()
            .asDriver()
        
        let input = HomeForMemberViewModel.Input(
            viewWillAppear: viewWillAppear.asDriver(),
            cellTapped: cellTapped.asDriver(),
            attendanceButtonTapped: attendanceButtonTapped.asDriver(),
            noticeButtonTapped: noticeButtonTapped,
            settingButtonTapped: settingButtonTapped
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.homeItem
            .withUnretained(self)
            .sink { owner, data in
                owner.updateUI(with: data)
            }.store(in: cancelBag)
        
        output.isLoading
            .withUnretained(self)
            .sink { owner, isLoading in
                isLoading ? owner.showLoading() : owner.stopLoading()
            }
            .store(in: cancelBag)
    }
    
    private func updateUI(with data: HomePresentationModel) {
        if isFirstAppear {
            applySnapshot(with: data)
            isFirstAppear = false
        } else {
            setItemsNeedUpdate(data)
        }
        updateNaviBarUI(isAllConfirm: data.dashBoard.isAllConfirm)
    }
    
    private func updateNaviBarUI(isAllConfirm: Bool?) {
        if let isAllConfirm = isAllConfirm {
            self.naviBar.changeNoticeButtonStyle(isActive: !isAllConfirm)
        }
    }
    
    private func applySnapshot(with data: HomePresentationModel) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeForMemberSectionLayoutKind, HomeForMemberItem>()
        
        // TODO: 이후 스프린트에서 순차 배포
//        snapshot.appendSections(HomeForMemberSectionLayoutKind.allCases)
        snapshot.appendSections([.dashBoard, .calendar, .mainProduct, .appService])
        
        snapshot.appendItems([.dashBoard(data.dashBoard)], toSection: .dashBoard)
        snapshot.appendItems([.recentSchedule(data.recentSchedule)], toSection: .calendar)
        snapshot.appendItems(self.viewModel.productServiceList.map { .productService($0) }, toSection: .mainProduct)
        snapshot.appendItems(data.appServices.map { .appService($0) }, toSection: .appService)
        // TODO: 이후 스프린트에서 순차 배포
//        snapshot.appendItems([.insightPost(data.insightPosts.first!)], toSection: .insight) // 임시로 첫 번째 값만 배정
//        snapshot.appendItems(data.groupPosts.map { .groupPost($0) }, toSection: .group)
//        snapshot.appendItems(data.coffeeChatPosts.map { .coffeeChat($0) }, toSection: .coffeeChat)
//        snapshot.appendItems(data.announcementPosts.map { .announcement($0) }, toSection: .announcement)
//        snapshot.appendItems(SocialLinkCardType.allCases.map { .socialLink($0) }, toSection: .socialLinks)
//        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setItemsNeedUpdate(_ data: HomePresentationModel) {
        var snapshot = self.dataSource.snapshot()
        
        let items: [HomeForMemberItem] = [
            .dashBoard(data.dashBoard),
            .recentSchedule(data.recentSchedule)
        ] + data.appServices.map { .appService($0) }
        
        let existingItems = snapshot.itemIdentifiers.filter { items.contains($0) }
        
        if !existingItems.isEmpty {
            snapshot.reconfigureItems(existingItems)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeForMemberVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            switch selectedItem {
            case .dashBoard(let model):
                self.cellTapped.send(.dashBoard(model))
            case .recentSchedule(let model):
                self.cellTapped.send(.recentSchedule(model))
            case .productService(let model):
                self.cellTapped.send(.productService(model))
            case .appService(let model):
                self.cellTapped.send(.appService(model))
            default: return
            }
        }
    }
}
