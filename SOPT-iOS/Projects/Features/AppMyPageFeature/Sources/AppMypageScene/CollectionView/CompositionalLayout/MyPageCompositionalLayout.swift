//
//  MyPageCompositionalLayout.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

extension AppMyPageVC {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let sectionKind = MyPageSectionLayoutKind(rawValue: sectionIndex) else { return self?.createEmptySection() }
            switch sectionKind {
            case .profile:
                return self?.createProfileSection()
            case .soptlogPreview:
                return self?.createSoptlogPreviewSection()
            case .soptlogCheckButton:
                return self?.createSoptlogCheckButtonSection()
            default:
                return self?.createMyPageSection()
            }
        }
    }

    private func createProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 12, trailing: 20)

        return section
    }

    private func createSoptlogPreviewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(57))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(114))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: MyPageSoptlogPreviewBackgroundView.className)

        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [backgroundView]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 16, trailing: 20)

        return section
    }

    private func createSoptlogCheckButtonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(36))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)

        return section
    }

    private func createMyPageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(42))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(185))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        /// 섹션 헤더
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(15))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: -16,
                                                              leading: 0,
                                                              bottom: 0,
                                                              trailing: 0)
        /// 섹션 데코레이션 아이템
        let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: MyPageSectionBackgroundView.className)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.decorationItems = [backgroundView]
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: 20,
                                                        bottom: 32,
                                                        trailing: 20)


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
