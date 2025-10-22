//
//  ClapListCompositionalLayout.swift
//  StampFeature
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

extension ClapListVC {

    static let standardWidth = UIScreen.main.bounds.width - 40.adjusted

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch ClapListSection.allCases[sectionIndex] {
            case .main:
                return self?.createClapListSection()
            }
        }
    }

    private func createClapListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(72.adjustedH)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(ClapListVC.standardWidth),
            heightDimension: .estimated(72.adjustedH)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: 20.adjusted,
            bottom: 0,
            trailing: 20.adjusted
        )
        section.interGroupSpacing = 10.adjustedH
        section.orthogonalScrollingBehavior = .none

        return section
    }
}
