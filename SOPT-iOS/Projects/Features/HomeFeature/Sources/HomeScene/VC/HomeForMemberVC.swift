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
    private var cancelBag = CancelBag()

    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    ).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .clear
    }
    
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
        bindViewModels()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
        bindViewModels()
    }
}

// MARK: - UI & Layout

extension HomeForMemberVC {
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

extension HomeForMemberVC {
    private func bindViewModels() {
        let input = HomeForMemberViewModel
            .Input(viewDidLoad: Just<Void>(()).asDriver())
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.needToReload
            .withUnretained(self)
            .sink { owner, _ in
                owner.collectionView.reloadData()
            }.store(in: cancelBag)
    }
    
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
        self.collectionView.register(CalendarCardCVC.self,
                                     forCellWithReuseIdentifier: CalendarCardCVC.className)
        self.collectionView.register(MainProductCardCVC.self,
                                     forCellWithReuseIdentifier: MainProductCardCVC.className)
        self.collectionView.register(AppServiceCardCVC.self,
                                     forCellWithReuseIdentifier: AppServiceCardCVC.className)
        self.collectionView.register(InsightCardCVC.self,
                                     forCellWithReuseIdentifier: InsightCardCVC.className)
        self.collectionView.register(GroupCardCVC.self,
                                     forCellWithReuseIdentifier: GroupCardCVC.className)
        self.collectionView.register(CoffeeChatCardCVC.self,
                                     forCellWithReuseIdentifier: CoffeeChatCardCVC.className)
        self.collectionView.register(AnnouncementCardCVC.self,
                                     forCellWithReuseIdentifier: AnnouncementCardCVC.className)
        
        /// Footer
        self.collectionView.register(AnnouncementPageContolFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: AnnouncementPageContolFooterView.className)
        self.collectionView.register(SocialLinkCardCVC.self,
                                     forCellWithReuseIdentifier: SocialLinkCardCVC.className)
    }
    
    private func bindViewModels() {
        let input = HomeForMemberViewModel.Input(
            cellTapped: cellTapped.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeForMemberVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension HomeForMemberVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTapped.send(indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeForMemberSectionLayoutKind.allCases.count
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: indexPath.section) else { return UICollectionReusableView() }
        
        /// Header View
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: HomeDefaultHeaderView.className,
                                                  for: indexPath) as? HomeDefaultHeaderView else { return UICollectionReusableView() }
            headerView.setDataForMember(sectionKind: sectionKind)
            return headerView
        } /// Footer View
        else if kind == UICollectionView.elementKindSectionFooter {
            switch sectionKind {
            case .announcement:
                guard let footerView = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: AnnouncementPageContolFooterView.className,
                                                      for: indexPath) as? AnnouncementPageContolFooterView else { return UICollectionReusableView() }
                footerView.bind(input: viewModel.currentCardPage,
                                pageNumber: viewModel.announcementInfoList.count)
                return footerView
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: section) else { return 0 }
        
        switch sectionKind {
        case .dashBoard: return 1
        case .calendar: return 1
        case .mainProduct: return viewModel.productInfoList.count
        case .appService: return viewModel.appServiceInfoList.count
        case .insight: return viewModel.insightInfoList.count
        case .group: return viewModel.groupInfoList.count
        case .coffeeChat: return viewModel.coffeeChatHostInfoList.count
        case .announcement: return viewModel.announcementInfoList.count
        case .socialLinks: return SocialLinkCardType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionKind {
        case .dashBoard:
            /// 대시보드 카드 셀
            guard let dashBoardCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: DashBoardCardCVC.className,
                                     for: indexPath) as? DashBoardCardCVC else { return UICollectionViewCell() }
            dashBoardCardCell.configureCell(userType: viewModel.userType,
                                            description: viewModel.homeDescription?.description)
            
            return dashBoardCardCell
            
        case .calendar:
            /// 캘린더 카드 셀
            guard let calendarCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CalendarCardCVC.className,
                                     for: indexPath) as? CalendarCardCVC else { return UICollectionViewCell() }
            calendarCardCell.configureCell(model: viewModel.recentSchedule,
                                           userType: viewModel.userType)
            
            return calendarCardCell
            
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
            appServiceCardCell.configureCell(imageURL: appService.imageURL,
                                             name: appService.name,
                                             badgeText: appService.badgeText)
            
            return appServiceCardCell
        
        case .insight:
            /// 인사이트 카드 셀
            let insightIndex = indexPath.item
            guard let insight = viewModel.insightInfoList[safe: insightIndex] else { return UICollectionViewCell() }
            guard let insightCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: InsightCardCVC.className,
                                     for: indexPath) as? InsightCardCVC else { return UICollectionViewCell() }
            insightCardCell.configureCell(model: insight)
            
            return insightCardCell
            
        case .group:
            /// 모임 카드 셀
            let groupIndex = indexPath.item
            guard let groupCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: GroupCardCVC.className,
                                     for: indexPath) as? GroupCardCVC else { return UICollectionViewCell() }
            groupCardCell.configureCell(model: viewModel.groupInfoList[groupIndex])
            
            return groupCardCell
            
        case .coffeeChat:
            /// 커피챗 카드 셀
            let coffeeChatIndex = indexPath.item
            guard let coffeeChatCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CoffeeChatCardCVC.className,
                                     for: indexPath) as? CoffeeChatCardCVC else { return UICollectionViewCell() }
            coffeeChatCardCell.configureCell(model: viewModel.coffeeChatHostInfoList[coffeeChatIndex])
            
            return coffeeChatCardCell

        case .announcement:
            /// 홍보 카드 셀
            let announcementIndex = indexPath.item
            guard let announcementCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: AnnouncementCardCVC.className,
                                     for: indexPath) as? AnnouncementCardCVC else { return UICollectionViewCell() }
            announcementCardCell.configureCell(model: viewModel.announcementInfoList[announcementIndex])
            
            return announcementCardCell
            
        case .socialLinks:
            /// 소셜 링크 카드 셀
            let socialLinkIndex = indexPath.item
            guard let socialLinkCardCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: SocialLinkCardCVC.className,
                                     for: indexPath) as? SocialLinkCardCVC else { return UICollectionViewCell() }
            let socialLinkType = SocialLinkCardType.allCases[socialLinkIndex]
            socialLinkCardCell.configureCell(type: socialLinkType)
            
            return socialLinkCardCell
        }
    }
}
