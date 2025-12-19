//
//  AppJamRankingVC.swift
//  StampFeature
//
//  Created by 강윤서 on 12/16/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

import SnapKit

final class AppJamRankingVC: UIViewController, AppJamRankingViewControllable {
    
    // MARK: - Properties
    
    private let viewModel: AppJamRankingViewModel
    private var cancelBag = CancelBag()
    private lazy var dataSource: UICollectionViewDiffableDataSource<AppJamRankingSection, AppJamRankingItem>! = nil
    
    // MARK: - UI Components
    
    private let naviBar = STNavigationBar(type: .titleWithLeftButton)
        .setTitleTypoStyle(.SoptampFont.h2)
        .setTitle(I18N.RankingList.rankingForPartTitle)
        .setRightButton(.none)
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = DSKitAsset.Colors.gray950.color
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refresher
        return collectionView
    }()
    
    private let refresher: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCells()
        setDataSource()
        applySnapshot()
    }
    
    // MARK: - Initialization
    
    init(viewModel: AppJamRankingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AppJamRankingVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension AppJamRankingVC {
    private func endRefresh() {
        self.refresher.endRefreshing()
    }
}

// MARK: - CollectionView Setup

extension AppJamRankingVC {
    private func registerCells() {
        collectionView.register(
            AppJamMissionCardCVC.self,
            forCellWithReuseIdentifier: AppJamMissionCardCVC.className
        )
        collectionView.register(
            AppJamRankingCVC.self,
            forCellWithReuseIdentifier: AppJamRankingCVC.className
        )
        collectionView.register(
            AppJamRankingHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AppJamRankingHeaderView.className
        )
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AppJamRankingSection, AppJamRankingItem>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            guard let section = AppJamRankingSection(rawValue: indexPath.section) else {
                return UICollectionViewCell()
            }
            
            switch section {
            case .missionCards:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AppJamMissionCardCVC.className,
                    for: indexPath
                ) as? AppJamMissionCardCVC else {
                    return UICollectionViewCell()
                }
                // TODO: 실제 데이터로 교체
                cell.configureCell(missionImage: "https://picsum.photos/146/232", time: "1분 전", missionTitle: "스터디룸 청소하기", userName: "노바고은비")
                return cell
                
            case .ranking:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AppJamRankingCVC.className,
                    for: indexPath
                ) as? AppJamRankingCVC else {
                    return UICollectionViewCell()
                }
                // TODO: 실제 데이터로 교체
                cell.configureCell(
                    rank: indexPath.row + 1,
                    teamName: "노바",
                    totalScore: 3000,
                    incrementScore: 1000
                )
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: AppJamRankingHeaderView.className,
                    for: indexPath
                  ) as? AppJamRankingHeaderView,
                  let section = AppJamRankingSection(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            switch section {
            case .missionCards:
                headerView.configure(
                    title: I18N.AppJamRankingList.appjamMissionTitle,
                    subtitle: I18N.AppJamRankingList.appjamMissionSubTitle,
                    image: DSKitAsset.Assets.icFire.image
                )
            case .ranking:
                headerView.configure(
                    title: I18N.AppJamRankingList.todayRankingTitle,
                    subtitle: I18N.AppJamRankingList.todayRankingSubTitle,
                    image: DSKitAsset.Assets.icPrize.image
                )
            }
            
            return headerView
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<AppJamRankingSection, AppJamRankingItem>()
        
        snapshot.appendSections([.missionCards, .ranking])
        
        // 임시 데이터 - TODO: 실제 데이터로 교체
        let missionCardItems = Array(0..<5).map { AppJamRankingItem.mission("mission_\($0)") }
        snapshot.appendItems(missionCardItems, toSection: .missionCards)
        
        let rankingItems = Array(0..<8).map { AppJamRankingItem.ranking("ranking_\($0)") }
        snapshot.appendItems(rankingItems, toSection: .ranking)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
