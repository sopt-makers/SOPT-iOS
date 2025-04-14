//
//  TabBarFABMenuVC.swift
//  TabBarFeature
//
//  Created by 강윤서 on 4/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class TabBarFABMenuVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = self.createLayout()
        layout.register(FABMenuDecorationView.self, forDecorationViewOfKind: FABMenuDecorationView.className)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        configureCollectionView()
    }
}

// MARK: - UI & Layout

extension TabBarFABMenuVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.black.color.withAlphaComponent(0.6)
    }
    
    private func setLayout() {
        view.addSubviews(menuCollectionView)
        
        menuCollectionView.snp.makeConstraints { make in
            make.height.equalTo(299)
            make.bottom.equalToSuperview().inset(122)
            make.leading.trailing.equalToSuperview().inset(107)
        }
    }
}

// MARK: - Methods

extension TabBarFABMenuVC {
    private func configureCollectionView() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.register(FABMenuCVC.self, forCellWithReuseIdentifier: FABMenuCVC.className)
        menuCollectionView.register(FABMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FABMenuHeaderView.className)
    }
}

// MARK: - UICollectionViewDelegate

extension TabBarFABMenuVC: UICollectionViewDelegateFlowLayout {

}

extension TabBarFABMenuVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TabBarMenuSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let menuSection = TabBarMenuSection.allCases[section]
        return menuSection.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FABMenuCVC.className, for: indexPath) as? FABMenuCVC else { return UICollectionViewCell() }
        
        let menuSection = TabBarMenuSection.allCases[indexPath.section]
        cell.configureCell(model: menuSection.items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: FABMenuHeaderView.className,
                                              for: indexPath) as? FABMenuHeaderView
        else { return UICollectionReusableView() }
    
        headerView.configureCell(title: TabBarMenuSection.allCases[indexPath.section].title)
        return headerView
    }
}
