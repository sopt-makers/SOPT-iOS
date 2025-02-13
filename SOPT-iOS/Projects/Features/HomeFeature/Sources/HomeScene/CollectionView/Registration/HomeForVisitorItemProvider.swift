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
    func createDashBoardCellRegistration() -> UICollectionView.CellRegistration<DashBoardCardCVC, HomePresentationModel.Description> {
        collectionView.createCellRegistration { [weak self] cell, _, _ in
            guard let self else { return }
            cell.configureCell(userType: self.viewModel.userType)
        }
    }
    
    func createProductCellRegistration() -> UICollectionView.CellRegistration<MainProductCardCVC, HomePresentationModel.ProductService> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(title: item.name, image: item.image)
        }
    }
    
    func createAppServiceCellRegistration() -> UICollectionView.CellRegistration<AppServiceCardCVC, HomePresentationModel.AppService> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    // supplementary views
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<HomeDefaultHeaderView> {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, indexPath in
            guard let sectionKind = HomeForVisitorSectionLayoutKind(rawValue: indexPath.section) else { return }
            headerView.configureView(sectionKind: sectionKind)
        }
    }
}


