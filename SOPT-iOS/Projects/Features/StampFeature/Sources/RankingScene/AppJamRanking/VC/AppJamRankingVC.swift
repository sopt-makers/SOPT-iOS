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
import MDS

import SnapKit

final class AppJamRankingVC: UIViewController, AppJamRankingViewControllable {
    
    // MARK: - Properties

    private let viewModel: AppJamRankingViewModel
    private var cancelBag = CancelBag()
    private lazy var dataSource: UICollectionViewDiffableDataSource<AppJamRankingSection, AppJamRankingItem>! = nil

    private let viewWillAppearPublisher = PassthroughSubject<Void, Never>()
    private let teamCellTappedPublisher = PassthroughSubject<AppJamRankTodayPresentationModel, Never>()
    private let missionCellTappedPublisher = PassthroughSubject<AppJamRankRecentPresentationModel, Never>()
    
    // MARK: - UI Components
    
    private let naviBar = STNavigationBar(type: .titleWithLeftButton)
        .setTitle(I18N.RankingList.appJamTeamStatusTitle)
        .setRightButton(.none)
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = SemanticColor.Bg.Layer.basement
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
        setDelegate()
        registerCells()
        setDataSource()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearPublisher.send(())
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
        view.backgroundColor = SemanticColor.Bg.Layer.basement
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
    private func setDelegate() {
        collectionView.delegate = self
    }
    
    private func bindViewModel() {
        let input = AppJamRankingViewModel.Input(
            viewWillAppear: viewWillAppearPublisher.asDriver(),
            refreshStarted: refresher.publisher(for: .valueChanged).mapVoid().asDriver(),
            naviBackButtonTapped: naviBar.leftButtonTapped.asDriver(),
            teamCellTapped: teamCellTappedPublisher.asDriver(),
            missionCellTapped: missionCellTappedPublisher.asDriver()
        )

        let output = viewModel.transform(from: input, cancelBag: cancelBag)

        output.$todayRankingList
            .combineLatest(output.$recentMissionList)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, data in
                let (todayRanking, recentMissions) = data
                owner.applySnapshot(todayRanking: todayRanking, recentMissions: recentMissions)
            }.store(in: cancelBag)

        output.isLoading
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, isLoading in
                if !isLoading {
                    owner.endRefresh()
                }
            }.store(in: cancelBag)
    }

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
            switch item {
            case .mission(let model):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AppJamMissionCardCVC.className,
                    for: indexPath
                ) as? AppJamMissionCardCVC else {
                    return UICollectionViewCell()
                }
                cell.configureCell(model: model)
                return cell

            case .ranking(let model):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AppJamRankingCVC.className,
                    for: indexPath
                ) as? AppJamRankingCVC else {
                    return UICollectionViewCell()
                }
                cell.configureCell(model: model)
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
                    title: I18N.AppJamRankingList.todayMissionAchievementBoardTitle,
                    subtitle: I18N.AppJamRankingList.todayMissionAchievementBoardSubTitle,
                    image: DSKitAsset.Assets.icPrize.image
                )
            }
            
            return headerView
        }
    }
    
    private func applySnapshot(
        todayRanking: [AppJamRankTodayPresentationModel],
        recentMissions: [AppJamRankRecentPresentationModel]
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<AppJamRankingSection, AppJamRankingItem>()

        snapshot.appendSections([.missionCards, .ranking])

        let missionCardItems = recentMissions.map { AppJamRankingItem.mission($0) }
        snapshot.appendItems(missionCardItems, toSection: .missionCards)

        let rankingItems = todayRanking.map { AppJamRankingItem.ranking($0) }
        snapshot.appendItems(rankingItems, toSection: .ranking)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension AppJamRankingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = AppJamRankingSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .ranking:
            guard let item = dataSource.itemIdentifier(for: indexPath),
                  case .ranking(let model) = item else { return }
            teamCellTappedPublisher.send(model)
        case .missionCards:
            guard let item = dataSource.itemIdentifier(for: indexPath),
                  case .mission(let model) = item else { return }
            missionCellTappedPublisher.send(model)
        }
    }
}
