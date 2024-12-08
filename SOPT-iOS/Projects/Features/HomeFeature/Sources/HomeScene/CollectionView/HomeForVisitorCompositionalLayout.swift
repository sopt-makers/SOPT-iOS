//
//  HomeForVisitorCompositionalLayout.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/9/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

extension HomeForVisitorVC {
    private enum Metric {
        static let collectionViewDefaultSideInset: Double = 20
        static let defaultItemSpacing: Double = 16
        static let defaultGroupSpacing: Double = 12
        static let defaultLineSpacing: Double = 56
        
        static let productItemSpacing: Double = 15
        static let appServiceItemSpacing: Double = 16
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: sectionIndex) else { return self.createEmptySection() }
            
            switch sectionKind {
            case .dashBoard:
                return self.createDashBoardSection()
            default:
                return self.createEmptySection()
            }
        }
    }
    
    private func createDashBoardSection() -> NSCollectionLayoutSection {
        /// header: 유저 정보 및 활동 히스토리
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(123))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// group 지정: 헤더만 존재
        let emptyGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(0))
        let emptyGroup = NSCollectionLayoutGroup.vertical(layoutSize: emptyGroupSize,
                                                          subitems: [])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: emptyGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createEmptySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(1),
                                              heightDimension: .absolute(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(1),
                                               heightDimension: .absolute(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
