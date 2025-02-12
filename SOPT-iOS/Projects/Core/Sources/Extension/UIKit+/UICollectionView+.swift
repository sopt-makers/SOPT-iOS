//
//  UICollectionView+.swift
//  Core
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func createCellRegistration<CellType: UICollectionViewCell, ModelType>(
        configure: @escaping (CellType, IndexPath, ModelType) -> Void
    ) -> UICollectionView.CellRegistration<CellType, ModelType> {
        UICollectionView.CellRegistration<CellType, ModelType> { (cell, indexPath, item) in
            configure(cell, indexPath, item)
        }
    }

    func createSupplementaryRegistration<ViewType: UICollectionReusableView>(
        elementKind: String,
        configure: @escaping (ViewType, IndexPath) -> Void
    ) -> UICollectionView.SupplementaryRegistration<ViewType> {
        UICollectionView.SupplementaryRegistration<ViewType>(
            elementKind: elementKind
        ) { (supplementaryView, _, indexPath) in
            configure(supplementaryView, indexPath)
        }
    }
}
