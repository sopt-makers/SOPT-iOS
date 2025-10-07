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
                .store(in: cell.cancelBag)
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
    
    func createPopularPostCellRegistration() -> PopularPostCellRegistration {
        collectionView.createCellRegistration { [weak self] cell, index, item in
            guard let self else { return }
            cell.configureCell(model: item, index: index, cellType: .popular)
            cell.setPostInfo(model: item, section: .latestPosts)
            
            cell.profileImageViewTap
                .withUnretained(self)
                .sink { owner, info in
                    owner.profileImageViewTapped.send(info)
                }
                .store(in: cell.cancelBag)
        }
    }
    
    func createLatestPostCellRegistration() -> LatestPostCellRegistration {
        collectionView.createCellRegistration { [weak self] cell, index, item in
            guard let self else { return }
            cell.configureCell(model: item, index: index, cellType: .latest)
            cell.setPostInfo(model: item, section: .realTimeFeed)
            
            cell.profileImageViewTap
                .withUnretained(self)
                .sink { owner, info in
                    owner.profileImageViewTapped.send(info)
                }
                .store(in: cell.cancelBag)
        }
    }
    
    func createSurveyRegistration() -> SurveyCellRegistration {
        collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            cell.configureCell(model: item)
            
            cell.surveyButtonTap
                .withUnretained(self)
                .sink { owner, _ in
                    owner.surveyButtonTapped.send()
                }
                .store(in: cell.cancelBag)
        }
    }
    
    func createSocialLinkCellRegistration() -> SocialLinkCellRegistration {
        collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(type: item.socialLink)
        }
    }
    
    // supplementary views
    func createHeaderRegistration() -> HeaderRegistration {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] headerView, indexPath in
            guard let self else { return }
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: indexPath.section) else { return }
            headerView.configureView(sectionKind: sectionKind)
            
            headerView.viewAllContentButtonTap
                .withUnretained(self)
                .sink { owner, _ in
                    owner.viewAllButtonTapped.send()
                }
                .store(in: headerView.cancelBag)
        }
    }
    
    func createLatestPostFooterRegistration() -> LatestPostFooterRegistration {
        collectionView.createSupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionFooter
        ) { _, _ in }
    }
}
