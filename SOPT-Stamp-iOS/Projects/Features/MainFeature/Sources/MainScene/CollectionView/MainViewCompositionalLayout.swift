//
//  MainViewCompositionalLayout.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

extension MainVC {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            switch MainViewSectionLayoutKind.type(sectionIndex) {
            case .userHistory: return self.createUserInfoSection()
            case .mainService: return self.createMainServiceSection()
            case .otherService: return self.createMainServiceSection()
            case .appService: return self.createMainServiceSection()
            }
        }
    }
    
    private func createUserInfoSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let historyItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24))
        let historyItem = NSCollectionLayoutItem(layoutSize: historyItemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [historyItem])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 20)
        return section
    }
    
    private func createMainServiceSection() -> NSCollectionLayoutSection {
        
        let historyItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(23))
        let historyItem = NSCollectionLayoutItem(layoutSize: historyItemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(71))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [historyItem])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
