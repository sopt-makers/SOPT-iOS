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

final class AppJamRankingVC: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private lazy var dataSource: UICollectionViewDiffableDataSource<AppJamRankingSection, AnyHashable>! = nil
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = DSKitAsset.Colors.gray950.color
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
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
}

// MARK: - UI & Layout

extension AppJamRankingVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
        dataSource = UICollectionViewDiffableDataSource<AppJamRankingSection, AnyHashable>(
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
                cell.configureCell(time: "1분 전", teamName: "노바고은비")
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
        var snapshot = NSDiffableDataSourceSnapshot<AppJamRankingSection, AnyHashable>()
        
        snapshot.appendSections([.missionCards, .ranking])
        
        // 임시 데이터 - TODO: 실제 데이터로 교체
        let missionCardItems = Array(0..<5).map { "mission_\($0)" }
        snapshot.appendItems(missionCardItems, toSection: .missionCards)
        
        let rankingItems = Array(0..<8).map { "ranking_\($0)" }
        snapshot.appendItems(rankingItems, toSection: .ranking)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
