//
//  PartRankingCompositionalLayout.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/03/31.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

extension PartRankingVC {
    static let standardWidth = UIScreen.main.bounds.width - 40.adjusted

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch RankingSection.type(sectionIndex) {
            case .chart: return self.createChartSection()
            case .list: return self.createListSection()
            }
        }
    }

    private func createChartSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(RankingVC.standardWidth - 28.adjusted), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 34.adjusted, bottom: 0, trailing: 34.adjusted)
        section.orthogonalScrollingBehavior = .none
        return section
    }

    private func createListSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(79.adjustedH))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 28.adjustedH, leading: 20.adjusted, bottom: 60.adjustedH, trailing: 20.adjusted)
        section.interGroupSpacing = .init(10.adjustedH)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}

