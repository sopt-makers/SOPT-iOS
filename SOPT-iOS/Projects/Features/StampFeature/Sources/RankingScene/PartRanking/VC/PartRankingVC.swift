//
//  PartRankingVC.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/03/31.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit
import MDS

import Combine
import SnapKit
import Then

import StampFeatureInterface
import BaseFeatureDependency

public class PartRankingVC: UIViewController, PartRankingViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: PartRankingViewModel
    private var cancelBag = CancelBag()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<RankingSection, AnyHashable>! = nil
    
    private let cellTapped = PassthroughSubject<Part, Never>()
    private let naviBackButtonTapped = PassthroughSubject<Void, Never>()
    private let rightButtonTapped = PassthroughSubject<Void, Never>()
        
    // MARK: - UI Components
    
    private lazy var naviBar = STNavigationBar(type: .titleWithLeftButton)
        .setTitle(I18N.RankingList.partRankingTitle)
        .setRightButton(.edit)
    
    private lazy var rankingCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        cv.showsVerticalScrollIndicator = true
        cv.backgroundColor = SemanticColor.Bg.Layer.basement
        cv.refreshControl = refresher
        return cv
    }()
    
    private let refresher: UIRefreshControl = {
        let rf = UIRefreshControl()
        return rf
    }()
    
    // MARK: - View Life Cycle
    private let rankingViewType: RankingViewType
    
    init(
        rankingViewType: RankingViewType,
        viewModel: PartRankingViewModel
    ) {
        self.rankingViewType = rankingViewType
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        guard case .currentGeneration(let info) = rankingViewType else { return }
        
        let navigationTitle = String(describing: info.currentGeneration) + "기 랭킹"
        self.naviBar.setTitle(navigationTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDataSource()
        self.setDelegate()
        self.registerCells()
        self.bindViews()
        self.bindViewModels()
    }
}

// MARK: - UI & Layouts

extension PartRankingVC {
    
    private func setUI() {
        self.view.backgroundColor = SemanticColor.Bg.Layer.basement
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, rankingCollectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        rankingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension PartRankingVC {
    
    private func bindViews() {
        naviBar.leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.naviBackButtonTapped.send(())
            }.store(in: cancelBag)
        
        naviBar.rightButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.rightButtonTapped.send(())
            }.store(in: cancelBag)
    }
    
    private func bindViewModels() {
        let refreshStarted = refresher.publisher(for: .valueChanged)
            .mapVoid()
            .asDriver()
        
        let input = PartRankingViewModel.Input(
            viewDidLoad: Driver.just(()),
            refreshStarted: refreshStarted,
            cellTapped: cellTapped.asDriver(),
            naviBackButtonTapped: naviBackButtonTapped.asDriver(),
            rightButtonTapped: rightButtonTapped.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.partRanking
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink(receiveValue: { owner, partRankingModels in
                owner.applySnapshot(model: partRankingModels)
                owner.endRefresh()
            }).store(in: cancelBag)
    }
    
    private func setDelegate() {
        rankingCollectionView.delegate = self
    }
    
    private func registerCells() {
        PartRankingChartCVC.register(target: rankingCollectionView)
        PartRankingListCVC.register(target: rankingCollectionView)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: rankingCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch RankingSection.type(indexPath.section) {
            case .chart:
                guard let chartCell = collectionView.dequeueReusableCell(withReuseIdentifier: PartRankingChartCVC.className, for: indexPath) as? PartRankingChartCVC,
                      let chartCellModel = itemIdentifier as? PartRankingChartModel else { return UICollectionViewCell() }
                chartCell.setData(model: chartCellModel)
                return chartCell
                
            case .list:
                guard let rankingListCell = collectionView.dequeueReusableCell(withReuseIdentifier: PartRankingListCVC.className, for: indexPath) as? PartRankingListCVC,
                      let model = itemIdentifier as? PartRankingModel else { return UICollectionViewCell() }
                rankingListCell.setData(model: model)
                
                return rankingListCell
            }
        })
    }
    
    func applySnapshot(model: [PartRankingModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<RankingSection, AnyHashable>()
        snapshot.appendSections([.chart, .list])
        let chartCellModel = PartRankingChartModel.init(ranking: model)
        snapshot.appendItems([chartCellModel], toSection: .chart)
        let listModels = model.sorted(by: { $0.rank < $1.rank })
        snapshot.appendItems(listModels, toSection: .list)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.view.setNeedsLayout()
    }
    
    private func endRefresh() {
        self.refresher.endRefreshing()
    }
}

extension PartRankingVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section >= 1 else { return }
        
        guard let tappedCell = collectionView.cellForItem(at: indexPath) as? PartRankingListCVC,
              let model = tappedCell.model else { return }
        guard let part = Part(rawValue: model.part) else { return }
        self.cellTapped.send(part)
    }
}
