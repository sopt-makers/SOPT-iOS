//
//  MissionListCompositionalLayout.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension MissionListVC {
    static let standardWidth = UIScreen.main.bounds.width - 40.adjusted
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch MissionListSection.type(sectionIndex) {
            case .sentence: return self.createSentenceSection()
            case .missionList: return self.createMissionListSection()
            }
        }
    }
    
    private func createSentenceSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(MissionListVC.standardWidth), heightDimension: .estimated(97))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return section
    }
    
    private func createMissionListSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(164.adjusted), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(MissionListVC.standardWidth), heightDimension: .absolute(204.adjusted))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8.adjusted)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20.adjusted, bottom: 0, trailing: 20.adjusted)
        section.interGroupSpacing = .init(40.adjustedH)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
}
