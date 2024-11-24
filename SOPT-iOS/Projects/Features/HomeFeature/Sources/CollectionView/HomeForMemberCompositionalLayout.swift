//
//  HomeForMemberCompositionalLayout.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

extension HomeForMemberVC {
    private enum Metric {
        static let collectionViewDefaultSideInset: Double = 20
        static let defaultItemSpacing: Double = 16
        static let defaultLineSpacing: Double = 56
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let sectionKind = HomeForMemberSectionLayoutKind.type(sectionIndex)
            else { return self.createEmptySection() }
            
            switch sectionKind {
            case .mainService:
                return self.createMainServiceSection()
            default:
                return self.createEmptySection()
            }
        }
    }
    
    private func createMainServiceSection() -> NSCollectionLayoutSection {
        /// header: 유저 정보 및 활동 히스토리
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(123))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// item: 캘린더 카드
        let calendarItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(56))
        let calendarItem = NSCollectionLayoutItem(layoutSize: calendarItemSize)
        
        /// group 지정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(295))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [calendarItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
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
