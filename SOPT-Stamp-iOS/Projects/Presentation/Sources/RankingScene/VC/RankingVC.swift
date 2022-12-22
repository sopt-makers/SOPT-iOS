//
//  RankingVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

public class RankingVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: RankingViewModel!
    private var cancelBag = CancelBag()
    public var factory: ModuleFactoryInterface!
    
    lazy var dataSource: UICollectionViewDiffableDataSource<RankingSection, AnyHashable>! = nil
    
    // MARK: - UI Components
    
    lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle("랭킹")
        .setRightButton(.none)
        .setTitleTypoStyle(.h2)
    
    private lazy var rankingCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        cv.showsVerticalScrollIndicator = true
        cv.backgroundColor = .white
        cv.refreshControl = refresher
        refresher.addTarget(self, action: #selector(fetchData(_:)), for: .valueChanged)
        return cv
    }()
    
    private let refresher: UIRefreshControl = {
        let rf = UIRefreshControl()
        return rf
    }()
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCells()
        self.bindViewModels()
        self.setDataSource()
    }
}

// MARK: - UI & Layouts

extension RankingVC {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, rankingCollectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        rankingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension RankingVC {
    
    private func bindViewModels() {
        let input = RankingViewModel.Input(viewDidLoad: Driver.just(()))
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$rankingListModel
            .dropFirst()
            .withUnretained(self)
            .sink { owner, model in
                owner.applySnapshot(model: model)
            }.store(in: self.cancelBag)
    }
    
    private func setDelegate() {
        rankingCollectionView.delegate = self
    }
    
    private func registerCells() {
        RankingChartCVC.register(target: rankingCollectionView)
        RankingListCVC.register(target: rankingCollectionView)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: rankingCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch RankingSection.type(indexPath.section) {
            case .chart:
                guard let chartCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingChartCVC.className, for: indexPath) as? RankingChartCVC,
                      let chartCellModel = itemIdentifier as? RankingChartModel else { return UICollectionViewCell() }
                chartCell.setData(model: chartCellModel)
                
                return chartCell
                
            case .list:
                guard let rankingListCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingListCVC.className, for: indexPath) as? RankingListCVC,
                      let rankingListCellModel = itemIdentifier as? RankingModel else { return UICollectionViewCell() }
                rankingListCell.setData(model: rankingListCellModel, rank: indexPath.row + 1 + 3)
                
                return rankingListCell
            }
        })
    }
    
    func applySnapshot(model: [RankingModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<RankingSection, AnyHashable>()
        snapshot.appendSections([.chart, .list])
        guard let chartCellModels = Array(model[0...2]) as? [RankingModel],
              let rankingListModel = Array(model[3...model.count-1]) as? [RankingModel] else { return }
        let chartCellModel = RankingChartModel.init(ranking: chartCellModels)
        snapshot.appendItems([chartCellModel], toSection: .chart)
        snapshot.appendItems(rankingListModel, toSection: .list)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.view.setNeedsLayout()
    }
    
    @objc
    private func fetchData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            self.refresher.endRefreshing()
        }
    }
}

extension RankingVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tappedCell = collectionView.cellForItem(at: indexPath) as? RankingListTappble,
              let item = tappedCell.getModelItem() else { return }
        self.pushToOtherUserMissionListVC(item: item)
    }
    
    private func pushToOtherUserMissionListVC(item: RankingListTapItem) {
        let otherUserMissionListVC = factory.makeMissionListVC(sceneType: .ranking(userName: item.username,
                                                                                   sentence: item.sentence,
                                                                                   userId: item.userId))
        self.navigationController?.pushViewController(otherUserMissionListVC, animated: true)
    }
}
