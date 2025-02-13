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
        static let defaultSectionSpacing: Double = 36
        
        static let productItemSpacing: Double = 15
        static let appServiceItemSpacing: Double = 16
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: sectionIndex) else { return self.createEmptySection() }
            
            switch sectionKind {
            case .dashBoard:
                return self.createDashBoardSection()
            case .mainProduct:
                return self.createMainProductSection()
            case .appService:
                return self.createAppServiceSection()
            }
        }
    }
    
    private func createDashBoardSection() -> NSCollectionLayoutSection {
        /// item: 대시보드 카드
        let dashBoardItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(123))
        let dashBoardItem = NSCollectionLayoutItem(layoutSize: dashBoardItemSize)
        
        /// group: 대시보드 카드
        let dashBoardGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(123))
        let dashBoardGroup = NSCollectionLayoutGroup.vertical(layoutSize: dashBoardGroupSize,
                                                              subitems: [dashBoardItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: dashBoardGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultSectionSpacing,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createMainProductSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
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
        let section = NSCollectionLayoutSection(group: productGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 40,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createAppServiceSection() -> NSCollectionLayoutSection {
        /// header: default
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
        let section = NSCollectionLayoutSection(group: appServiceGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultLineSpacing,
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
