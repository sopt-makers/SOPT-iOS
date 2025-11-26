//
//  SoptlogCompositionalLayout.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

extension SoptlogVC {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            guard let self,
                  let sectionType = SoptlogSectionLayoutKind(rawValue: sectionIndex) else {
                return self?.createDefaultSection()
            }
            
            switch sectionType {
            case .logo:
                return self.createLogoSection()
            case .soptampLog, .pokeLog:
                return self.createMenuSection(sectionType: sectionType)
            case .banner:
                return self.createBannerSection()
            }
        })
        
        return layout
    }
    
    private func createDefaultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    private func createLogoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(240))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createMenuSection(sectionType: SoptlogSectionLayoutKind) -> NSCollectionLayoutSection {
        // 메뉴 아이템만
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(53))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        // Section header
        let topSpacing: CGFloat = sectionType == .soptampLog ? 36 : 28
        let headerHeight: CGFloat = topSpacing + 28  // topSpacing + 타이틀 높이
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(headerHeight)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = false
        
        // 헤더 제외
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: SoptlogSectionBackgroundDecorationView.className
        )
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(
            top: headerHeight,  // 헤더 높이만큼 top inset
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.decorationItems = [backgroundDecoration]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        // 배너 아이템
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(76))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 38, leading: 0, bottom: 0, trailing: 0)
        
        // Footer
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        footer.pinToVisibleBounds = false
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
}
