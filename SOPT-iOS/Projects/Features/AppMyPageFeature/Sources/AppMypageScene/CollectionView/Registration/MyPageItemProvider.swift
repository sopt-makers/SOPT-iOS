//
//  MyPageItemProvider.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

extension AppMyPageVC {
    func createMyPageeCellRegistration() -> MyPageCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    // supplementary views
    func createHeaderRegistration() -> MyPageHeaderRegistration {
        collectionView.createSupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { headerView, indexPath in
            guard let sectionKind = MyPageSectionLayoutKind(rawValue: indexPath.section) else { return }
            headerView.configureCell(title: sectionKind.title)
        }
    }
}
