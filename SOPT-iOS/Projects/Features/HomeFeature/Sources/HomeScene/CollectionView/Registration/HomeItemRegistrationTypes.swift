//
//  HomeItemRegistrationTypes.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

// cells
typealias DashBoardCardCellRegistration = UICollectionView.CellRegistration<DashBoardCardCVC, HomePresentationModel.DashBoard>
typealias CalendarCellRegistration = UICollectionView.CellRegistration<CalendarCardCVC, HomePresentationModel.RecentSchedule>
typealias ProductCellRegistration = UICollectionView.CellRegistration<MainProductCardCVC, HomePresentationModel.ProductService>
typealias AppServiceCellRegistration = UICollectionView.CellRegistration<AppServiceCardCVC, HomePresentationModel.AppService>
typealias PopularPostCellRegistration = UICollectionView.CellRegistration<DefaultPostCVC, HomePresentationModel.PopularPost>
typealias LatestPostCellRegistration = UICollectionView.CellRegistration<DefaultPostCVC, HomePresentationModel.LatestPost>
typealias SurveyCellRegistration = UICollectionView.CellRegistration<SurveyCVC, HomePresentationModel.Survey>
typealias SocialLinkCellRegistration = UICollectionView.CellRegistration<SocialLinkCardCVC, HomePresentationModel.SocialLink>

// supplemenatry views
typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HomeDefaultHeaderView>
typealias LatestPostFooterRegistration = UICollectionView.SupplementaryRegistration<LatestPostFooterView>

