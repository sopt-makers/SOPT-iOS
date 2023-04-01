//
//  MainVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import MainFeatureInterface
import StampFeatureInterface

public class MainVC: UIViewController, MainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    public var factory: StampFeatureViewBuildable!
    private var cancelBag = CancelBag()
    
    public var userType: UserType = .visitor
  
    // MARK: - UI Components
    
    private let naviBar = MainNavigationBar()
    
    private lazy var collectionView: UICollectionView = {
      let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
      cv.isScrollEnabled = true
      cv.showsHorizontalScrollIndicator = false
      cv.showsVerticalScrollIndicator = false
      cv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
      cv.backgroundColor = .clear
      return cv
    }()
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCells()
    }
}

// MARK: - UI & Layout

extension MainVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MainVC {
    private func bindViewModels() {
        let input = MainViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        self.collectionView.register(UserHistoryHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: UserHistoryHeaderView.className)
        self.collectionView.register(UserHistoryCVC.self, forCellWithReuseIdentifier: UserHistoryCVC.className)
        self.collectionView.register(MainServiceCVC.self, forCellWithReuseIdentifier: MainServiceCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        switch indexPath.section {
        case 0:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: UserHistoryHeaderView.className,
                                                  for: indexPath) as? UserHistoryHeaderView
            else { return UICollectionReusableView() }
            headerView.initCell(userType: userType, name: "이솝트", days: "1234")
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 4
        case 2: return 4
        case 3: return 4
        default: return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserHistoryCVC.className, for: indexPath) as? UserHistoryCVC else { return UICollectionViewCell() }
            cell.initCell(userType: self.userType, recentHistory: 32, allHistory: [31, 30, 29, 28, 27, 26, 25])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainServiceCVC.className, for: indexPath) as? MainServiceCVC else { return UICollectionViewCell() }
            return cell
        }
    }
}
