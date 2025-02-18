//
//  HomeForMemberCellProvider.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine

extension HomeForMemberVC {
    // cells
    func createDashBoardCellRegistration() -> DashBoardCardCellRegistration {
        collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            cell.configureCell(userType: self.viewModel.userType, model: item)
        }
    }
    
    func createCalendarCellRegistration() -> CalendarCellRegistration {
        collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            cell.configureCell(model: item, userType: self.viewModel.userType)
            
            cell.attendanceButtonTap
                .withUnretained(self)
                .sink { owner, _ in
                    owner.attendanceButtonTapped.send()
                }
                .store(in: cancelBag)
        }
    }
    
    func createProductCellRegistration() -> ProductCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(title: item.name, image: item.image)
        }
    }
    
    func createAppServiceCellRegistration() -> AppServiceCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createInsightCellRegistration() -> InsightCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createGroupCellRegistration() -> GroupCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createCoffeeChatCellRegistration() -> CoffeeChatCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createAnnouncementCellRegistration() -> AnnouncementCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }
    }
    
    func createSocialLinkCellRegistration() -> SocialLinkCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(type: item)
        }
    }
    
    // supplementary views
    func createHeaderRegistration() -> HeaderRegistration {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, indexPath in
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: indexPath.section) else { return }
            headerView.configureView(sectionKind: sectionKind)
        }
    }
    
    func createFooterRegistration() -> FooterRegistration {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionFooter
        ) { [weak self] footerView, indexPath in
            guard let self else { return }
            footerView.bind(input: self.viewModel.currentCardPage, pageNumber: 5)
        }
    }
}
