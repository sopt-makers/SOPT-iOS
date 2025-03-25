//
//  HomeForVisitorItemProvider.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

extension HomeForVisitorVC {
    // cells
    func createDashBoardCellRegistration() -> DashBoardCardCellRegistration {
        collectionView.createCellRegistration { [weak self] cell, _, _ in
            guard let self else { return }
            cell.configureCell(userType: self.viewModel.userType)
        }
    }
    
    func createProductCellRegistration() -> ProductCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item.product)
        }
    }
    
    func createAppServiceCellRegistration() -> AppServiceCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    // supplementary views
    func createHeaderRegistration() -> HeaderRegistration {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, indexPath in
            guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: indexPath.section) else { return }
            headerView.configureView(sectionKind: sectionKind)
        }
    }
}


