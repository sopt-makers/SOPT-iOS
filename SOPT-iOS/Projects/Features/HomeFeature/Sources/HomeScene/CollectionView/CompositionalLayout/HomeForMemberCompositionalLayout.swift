//
//  HomeForMemberCompositionalLayout.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core

extension HomeForMemberVC {
    private enum Metric {
        static let collectionViewDefaultSideInset: Double = 20
        static let defaultItemSpacing: Double = 16
        static let defaultGroupSpacing: Double = 12
        static let defaultLineSpacing: Double = 56
        
        static let productItemSpacing: Double = 15
        static let appServiceItemSpacing: Double = 16
        static let mainProductSectionSpacing: Double = 44
        static let announcementWidth: Double = 300
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: sectionIndex)
            else { return self.createEmptySection() }
            
            switch sectionKind {
            case .dashBoard:
                return self.createDashBoardSection()
            case .calendar:
                return self.createCalendarSection()
            case .mainProduct:
                return self.createMainProductSection()
            case .appService:
                return self.createAppServiceSection()
            case .insight:
                return self.createInsightSection()
            case .announcement:
                return self.createAnnouncementSection()
            case .group:
                return self.createGroupSection()
            case .coffeeChat:
                return self.createCoffeeChatSection()
            case .socialLinks:
                return self.createSocialLinksSection()
            }
        }
    }
    
    private func createDashBoardSection() -> NSCollectionLayoutSection {
        /// item: 유저 정보 및 활동 히스토리 카드
        let dashBoardItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(123))
        let dashBoardItem = NSCollectionLayoutItem(layoutSize: dashBoardItemSize)
        
        /// group: 유저 정보 및 활동 히스토리 카드
        let dashBoardGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(123))
        let dashBoardGroup = NSCollectionLayoutGroup.vertical(layoutSize: dashBoardGroupSize,
                                                              subitems: [dashBoardItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: dashBoardGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        return section
    }
    
    private func createCalendarSection() -> NSCollectionLayoutSection {
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
        let section = NSCollectionLayoutSection(group: calendarGroup)
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
        let section = NSCollectionLayoutSection(group: productGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.mainProductSectionSpacing,
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
    
    private func createInsightSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// item: 인사이트 카드
        let insightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(80))
        let insightItem = NSCollectionLayoutItem(layoutSize: insightItemSize)
        
        /// group: 인사이트 카드
        let insightGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .estimated(80))
        let insightGroup = NSCollectionLayoutGroup.horizontal(layoutSize: insightGroupSize,
                                                              subitems: [insightItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: insightGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultLineSpacing,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        return section
    }
    
    private func createGroupSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.contentInsets = .init(top: 0,
                                     leading: 0,
                                     bottom: 0,
                                     trailing: Metric.collectionViewDefaultSideInset)
        
        /// item: 모임 카드
        let groupItemSize = NSCollectionLayoutSize(widthDimension: .absolute(140),
                                                   heightDimension: .estimated(170))
        let groupItem = NSCollectionLayoutItem(layoutSize: groupItemSize)
        
        /// group: 모임 카드
        let groupGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(150),
                                                    heightDimension: .estimated(170))
        let groupGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupGroupSize,
                                                            subitems: [groupItem])
        groupGroup.interItemSpacing = .fixed(12)
        
        /// section 지정
        let section = NSCollectionLayoutSection(
            group: groupGroup
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultLineSpacing,
                                                        trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createCoffeeChatSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.contentInsets = .init(top: 0,
                                     leading: 0,
                                     bottom: 0,
                                     trailing: Metric.collectionViewDefaultSideInset)
        
        /// item: 커피챗 카드
        let coffeeChatItemSize = NSCollectionLayoutSize(widthDimension: .absolute(280),
                                                        heightDimension: .estimated(234))
        let coffeeChatItem = NSCollectionLayoutItem(layoutSize: coffeeChatItemSize)
        
        /// group: 커피챗 카드
        let coffeeChatGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(280),
                                                         heightDimension: .estimated(234))
        let coffeeChatGroup = NSCollectionLayoutGroup.horizontal(layoutSize: coffeeChatGroupSize,
                                                                 subitems: [coffeeChatItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(
            group: coffeeChatGroup
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultLineSpacing,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createAnnouncementSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// item: 홍보 카드
        let announcementItemSize = NSCollectionLayoutSize(widthDimension: .absolute(Metric.announcementWidth),
                                                          heightDimension: .absolute(308))
        let announctementItem = NSCollectionLayoutItem(layoutSize: announcementItemSize)
        
        /// group: 홍보 카드
        let announcementGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(Metric.announcementWidth),
                                                           heightDimension: .absolute(308))
        let announcementGroup = NSCollectionLayoutGroup.vertical(layoutSize: announcementGroupSize,
                                                              subitems: [announctementItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: announcementGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        /// footer: pageController 추가
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(24))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottomLeading)
        
        /// 포커스 중인 페이지 인덱스 계산
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, env in
            let pageWidth = Metric.announcementWidth
            let currentPage = Int(ceil(offset.x / (pageWidth + Metric.defaultGroupSpacing)))
            self?.viewModel.currentCardPage.send(currentPage)
        }

        section.boundarySupplementaryItems = [header, footer]
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 12
        return section
    }
    
    private func createSocialLinksSection() -> NSCollectionLayoutSection {
        /// item: 소셜 링크 카드
        let socialLinkItemSize = NSCollectionLayoutSize(widthDimension: .absolute(97),
                                                        heightDimension: .absolute(40))
        let socialLinkItem = NSCollectionLayoutItem(layoutSize: socialLinkItemSize)
        
        /// group: 소셜 링크 카드
        let socialLinkGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(97),
                                                         heightDimension: .absolute(40))
        let socialLinkGroup = NSCollectionLayoutGroup.vertical(layoutSize: socialLinkGroupSize,
                                                            subitems: [socialLinkItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: socialLinkGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultLineSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: 0,
                                                        trailing: 0)
        section.interGroupSpacing = 6
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
