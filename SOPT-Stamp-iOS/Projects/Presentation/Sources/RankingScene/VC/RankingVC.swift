//
//  RankingVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
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
        self.applySnapshot()
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
        let input = RankingViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
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
                guard let chartCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingChartCVC.className, for: indexPath) as? RankingChartCVC else { return UICollectionViewCell() }
                
                return chartCell
                
            case .list:
                guard let rankingListCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingListCVC.className, for: indexPath) as? RankingListCVC else { return UICollectionViewCell() }
                guard let index = itemIdentifier as? Int else { return UICollectionViewCell() }
                
                return rankingListCell
            }
        })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<RankingSection, AnyHashable>()
        snapshot.appendSections([.chart, .list])
        snapshot.appendItems([-1], toSection: .chart)
        var tempItems: [Int] = []
        for i in 0..<50 {
            tempItems.append(i)
        }
        snapshot.appendItems(tempItems, toSection: .list)
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
    
}
