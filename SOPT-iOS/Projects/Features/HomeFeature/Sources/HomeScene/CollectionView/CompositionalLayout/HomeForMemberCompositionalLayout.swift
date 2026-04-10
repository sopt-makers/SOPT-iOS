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
        static let popularPostsSectionSpacing: Double = 10
        static let mainProductSectionSpacing: Double = 44
        static let socialLinkSectionSpacing: Double = 72
        
        static let bottomSpacing: Double = 50
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: sectionIndex)
            else { return self?.createEmptySection() }
            
            switch sectionKind {
            case .dashBoard:
                return self?.createDashBoardSection()
            case .calendar:
                return self?.createCalendarSection()
            case .mainProduct:
                return self?.createMainProductSection()
            case .popularPosts:
                return self?.createPopularPostsSection()
            case .socialLinks:
                return self?.createSocialLinksSection()
            case .survey:
                return self?.createSurveySection()
            case .latestPosts:
                return self?.createLatestPostsSection()
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
    
    private func createPopularPostsSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// item: 실시간 인기글
        let popularPostsItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .absolute(122))
        let popularPostsItem = NSCollectionLayoutItem(layoutSize: popularPostsItemSize)
        
        /// group: 실시간 인기글
        let popularPostsGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .estimated(122))
        let popularPostsGroup = NSCollectionLayoutGroup.vertical(layoutSize: popularPostsGroupSize,
                                                                    subitems: [popularPostsItem])
        popularPostsGroup.interItemSpacing = .fixed(Metric.collectionViewDefaultSideInset)
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: popularPostsGroup)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = Metric.popularPostsSectionSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultLineSpacing,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        return section
    }
    
    
    private func createLatestPostsSection() -> NSCollectionLayoutSection {
        /// header: default
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        /// 화면 너비에서 좌우 inset을 뺀 값을 아이템 너비로 사용
        let itemWidth = UIScreen.main.bounds.width - (Metric.collectionViewDefaultSideInset * 2)
        
        /// item: 최신 게시글
        let latestPostItemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                        heightDimension: .absolute(122))
        let latestPostItem = NSCollectionLayoutItem(layoutSize: latestPostItemSize)
        
        /// group: 최신 게시글
        let latestPostGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                         heightDimension: .absolute(122))
        let latestPostGroup = NSCollectionLayoutGroup.horizontal(layoutSize: latestPostGroupSize,
                                                                 subitems: [latestPostItem])
        latestPostGroup.interItemSpacing = .fixed(Metric.collectionViewDefaultSideInset)
        
        /// footer: page control
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(4))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: latestPostGroup)
        section.boundarySupplementaryItems = [header, footer]
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultItemSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.defaultItemSpacing,
                                                        trailing: Metric.collectionViewDefaultSideInset)
        
        section.visibleItemsInvalidationHandler  = { [weak self] (item, point, env) in
            guard let self = self,
                  let footer = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter)
                .first(where: { ($0 as? LatestPostFooterView) != nil }) as? LatestPostFooterView else { return }
            
            let itemWidthWithInset: CGFloat = itemWidth + Metric.collectionViewDefaultSideInset
            let currentPage = Int(round(point.x / itemWidthWithInset))
            
            footer.updatePage(currentPage: currentPage)
        }
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.socialLinkSectionSpacing,
                                                        leading: Metric.collectionViewDefaultSideInset,
                                                        bottom: Metric.bottomSpacing,
                                                        trailing: 0)
        section.interGroupSpacing = 6
        return section
    }
    
    private func createSurveySection() -> NSCollectionLayoutSection {
        /// item: 설문
        let surveyItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(300))
        let surveyItem = NSCollectionLayoutItem(layoutSize: surveyItemSize)
        
        /// group: 설문
        let surveyGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(300))
        let surveyGroup = NSCollectionLayoutGroup.vertical(layoutSize: surveyGroupSize,
                                                           subitems: [surveyItem])
        
        /// section 지정
        let section = NSCollectionLayoutSection(group: surveyGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.defaultLineSpacing,
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
