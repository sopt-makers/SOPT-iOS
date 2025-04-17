//
//  TabBarFABCompositionalLayout.swift
//  TabBarFeature
//
//  Created by 강윤서 on 4/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

extension TabBarController {
    private enum Metric {
        static let collectionViewDefaultInset: Double = 14
        static let collectionViewTopInset: Double = 10
        static let collectionViewBottonInset: Double = 22
        
        static let sectionTitleTopInset: Double = 12
        static let sectionInterSpacing: Double = 8
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, evn in
            switch section {
            default:
                return self.createFABMenuSection()
            }
        }
    }
    
    private func createFABMenuSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        /// 섹션 별 헤더
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(15))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: -Metric.sectionTitleTopInset,
                                                              leading: 0,
                                                              bottom: 0,
                                                              trailing: 0)
        
        /// 섹션 데코레이션 아이템
        let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: FABMenuDecorationView.className)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.decorationItems = [backgroundView]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: Metric.collectionViewDefaultInset,
                                                        bottom: Metric.collectionViewBottonInset,
                                                        trailing: Metric.collectionViewDefaultInset)
        
        return section
    }
}
