//
//  SoptletterCompositionalLayout.swift
//  SoptletterFeature
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

extension SoptletterMainVC {

    func makePostItGridLayout(
        itemHeight: CGFloat,
        itemSpacing: CGFloat,
        sideInset: CGFloat,
        bottomInset: CGFloat
    ) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sideInset, bottom: bottomInset, trailing: sideInset)

        return UICollectionViewCompositionalLayout(section: section)
    }
}
