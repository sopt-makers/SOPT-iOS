//
//  HomeForMemberVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import BaseFeatureDependency

public final class HomeForMemberVC: UIViewController, HomeForMemberViewControllable {

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
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
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
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        self.collectionView.register(MainServiceHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: MainServiceHeaderView.className)
        self.collectionView.register(MainServiceCalendarCardCVC.self,
                                     forCellWithReuseIdentifier: MainServiceCalendarCardCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeForMemberVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension HomeForMemberVC: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeForMemberSectionLayoutKind.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        switch indexPath.section {
        case 0:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: MainServiceHeaderView.className,
                                                  for: indexPath) as? MainServiceHeaderView else { return UICollectionReusableView() }
            headerView.initCell(userType: .active)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: MainServiceCalendarCardCVC.className,
                                     for: indexPath) as? MainServiceCalendarCardCVC else { return UICollectionViewCell() }
            cell.initCell(date: "10.22",
                          tag: .event,
                          title: "1차 행사",
                          userType: .active)
            return cell
        default: return UICollectionViewCell()
        }
    }
}
