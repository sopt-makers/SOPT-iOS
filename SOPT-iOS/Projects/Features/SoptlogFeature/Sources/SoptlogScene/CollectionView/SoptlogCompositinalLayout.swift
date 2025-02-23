//
//  SoptlogCompositinalLayout.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

extension SoptlogVC {
    private enum Metric {
        static let collectionViewDefaultSideInset: Double = 20
        static let defaultGroupSpacing: Double = 12
        static let productItemSpacing: Double = 8
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let sectionKind = SoptlogSectionLayoutKind(rawValue: sectionIndex) else { return self.createEmptySection() }
            
            switch sectionKind {
            case .introduce: return self.createIntroduceSection()
            case .appService: return self.createAppServiceSection()
            case .editProfile: return self.createEditProfileSection()
            case .alarm: return self.createAlarmSection()
            }
        }
        
        layout.register(
            AppServiceSectionBackgroundView.self,
            forDecorationViewOfKind: AppServiceSectionBackgroundView.className)
        
        return layout
    }
    
    private func createIntroduceSection() -> NSCollectionLayoutSection {
        /// header: 유저 정보
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(80))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// item: 한 줄 소개
        let introduceItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(37))
        let introduceItem = NSCollectionLayoutItem(layoutSize: introduceItemSize)
        
        /// group: 한 줄 소개
        let introduceGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(37))
        let introduceGroup = NSCollectionLayoutGroup.vertical(layoutSize: introduceGroupSize,
                                                             subitems: [introduceItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: introduceGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createAppServiceSection() -> NSCollectionLayoutSection {
        /// item: 프로덕트
        let productItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                     heightDimension: .absolute(126))
        let productItem = NSCollectionLayoutItem(layoutSize: productItemSize)
        
        /// group: 프로덕트
        let productGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(126))
        let productGroup = NSCollectionLayoutGroup.horizontal(layoutSize: productGroupSize,
                                                              subitems: [productItem])
        productGroup.interItemSpacing = .fixed(Metric.productItemSpacing)
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: productGroup)
        let backgroundItem = NSCollectionLayoutDecorationItem.background(
            elementKind: AppServiceSectionBackgroundView.className)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultGroupSpacing,
                                                               leading: Metric.collectionViewDefaultSideInset,
                                                               bottom: 0,
                                                               trailing: Metric.collectionViewDefaultSideInset)
        section.decorationItems = [backgroundItem]
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultGroupSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
            
        return section
    }
    
    private func createEditProfileSection() -> NSCollectionLayoutSection {
        /// item: 프로필 수정
        let editProfileItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(36))
        let editProfileItem = NSCollectionLayoutItem(layoutSize: editProfileItemSize)
        
        /// group: 프로필 수정
        let editProfileGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(36))
        let editProfileGroup = NSCollectionLayoutGroup.horizontal(layoutSize: editProfileGroupSize,
                                                              subitems: [editProfileItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: editProfileGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createAlarmSection() -> NSCollectionLayoutSection {
        /// item: 알림
        let alarmItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(80))
        let alarmItem = NSCollectionLayoutItem(layoutSize: alarmItemSize)
        
        /// group: 알림
        let alarmGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(80))
        let alarmGroup = NSCollectionLayoutGroup.horizontal(layoutSize: alarmGroupSize,
                                                              subitems: [alarmItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: alarmGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 40,
                                                        leading: 0,
                                                        bottom: 0,
                                                        trailing: 0)
        
        return section
    }
    
    private func createEmptySection() -> NSCollectionLayoutSection {
        NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: .init(widthDimension: .absolute(0), heightDimension: .absolute(0))))
    }
}
