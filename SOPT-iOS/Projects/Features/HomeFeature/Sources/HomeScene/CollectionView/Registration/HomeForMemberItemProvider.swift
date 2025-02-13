//
//  HomeForMemberCellProvider.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

extension HomeForMemberVC {
    // cells
    func createDashBoardCellRegistration() -> UICollectionView.CellRegistration<DashBoardCardCVC, HomePresentationModel.Description> {
        collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            cell.configureCell(userType: self.viewModel.userType, description: item.description)
        }
    }
    
    func createCalendarCellRegistration() -> UICollectionView.CellRegistration<CalendarCardCVC, HomePresentationModel.RecentSchedule> {
        collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            cell.configureCell(model: item, userType: self.viewModel.userType)
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
    
    func createInsightCellRegistration() -> UICollectionView.CellRegistration<InsightCardCVC, HomePresentationModel.InsightPost> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createGroupCellRegistration() -> UICollectionView.CellRegistration<GroupCardCVC, HomePresentationModel.GroupPost> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createCoffeeChatCellRegistration() -> UICollectionView.CellRegistration<CoffeeChatCardCVC, HomePresentationModel.CoffeeChat> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createAnnouncementCellRegistration() -> UICollectionView.CellRegistration<AnnouncementCardCVC, HomePresentationModel.Announcement> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createSocialLinkCellRegistration() -> UICollectionView.CellRegistration<SocialLinkCardCVC, SocialLinkCardType> {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(type: item)
        }
    }
    
    // supplementary views
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<HomeDefaultHeaderView> {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, indexPath in
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: indexPath.section) else { return }
            headerView.configureView(sectionKind: sectionKind)
        }
    }
    
    func createFooterRegistration() -> UICollectionView.SupplementaryRegistration<AnnouncementPageContolFooterView> {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionFooter
        ) { [weak self] footerView, indexPath in
            guard let self else { return }
            footerView.bind(input: self.viewModel.currentCardPage, pageNumber: 5)
        }
    }
}
