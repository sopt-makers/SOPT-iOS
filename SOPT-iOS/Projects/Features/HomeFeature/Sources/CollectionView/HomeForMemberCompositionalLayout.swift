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
        static let defaultGroupSpacing: Double = 12
        static let defaultLineSpacing: Double = 56
        
        static let productItemSpacing: Double = 15
        static let appServiceItemSpacing: Double = 16
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: sectionIndex)
            else { return self.createEmptySection() }
            
            switch sectionKind {
            case .dashBoard:
                return self.createDashBoardSection()
            case .mainProduct:
                return self.createMainProductSection()
            case .appService:
                return self.createAppServiceSection()
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
        
        /// item: 캘린더 카드
        let calendarItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(56))
        let calendarItem = NSCollectionLayoutItem(layoutSize: calendarItemSize)
        
        /// group: 캘린더 카드
        let calendarGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(56))
        let calendarGroup = NSCollectionLayoutGroup.vertical(layoutSize: calendarGroupSize,
                                                             subitems: [calendarItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(
            group: NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(295)
                ),
                subitems: [calendarGroup]
            )
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createMainProductSection() -> NSCollectionLayoutSection {
        /// item: 프로덕트 카드
        let productItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                     heightDimension: .absolute(92))
        let productItem = NSCollectionLayoutItem(layoutSize: productItemSize)
        
        /// group: 프로덕트 카드
        let productGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(92))
        let productGroup = NSCollectionLayoutGroup.horizontal(layoutSize: productGroupSize,
                                                              subitems: [productItem])
        productGroup.interItemSpacing = .fixed(Metric.productItemSpacing)
        
        /// section 지정
        let section = NSCollectionLayoutSection(
            group: NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(295)
                ),
                subitems: [productGroup]
            )
        )
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 40,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createAppServiceSection() -> NSCollectionLayoutSection {
        /// header: 유저 정보 및 활동 히스토리
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// item: 앱 서비스 카드
        let appServiceItemSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                                        heightDimension: .absolute(106))
        let appServiceItem = NSCollectionLayoutItem(layoutSize: appServiceItemSize)
        
        /// group: 앱 서비스 카드
        let appServiceGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .estimated(106))
        let appServiceGroup = NSCollectionLayoutGroup.horizontal(layoutSize: appServiceGroupSize,
                                                               subitems: [appServiceItem])
        appServiceGroup.interItemSpacing = .fixed(Metric.appServiceItemSpacing)
        
        /// section 지정
        let section = NSCollectionLayoutSection(
            group: NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(106)
                ),
                subitems: [appServiceGroup]
            )
        )
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
