//
//  NotificationListViewCompositionalLayout.swift
//  NotificationFeatureDemo
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

// MARK: - CollectionViewLayout

extension NotificationListVC {
    func createFilterCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: createFilterSection(), configuration: config)
    }
    
    func createListCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: createNotificationListSection())
    }
    
    private func createFilterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0) , heightDimension: .absolute(23))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 13, leading: 20, bottom: 10, trailing: 0)
        
        return section
    }
    
    private func createNotificationListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
