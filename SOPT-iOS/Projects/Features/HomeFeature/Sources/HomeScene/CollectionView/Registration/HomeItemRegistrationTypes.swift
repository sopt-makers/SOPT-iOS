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
typealias PlaygroundNewsCellRegistration = UICollectionView.CellRegistration<PlaygroundNewsCardCVC, HomePresentationModel.PlaygroundNews>
typealias SocialLinkCellRegistration = UICollectionView.CellRegistration<SocialLinkCardCVC, SocialLinkCardType>

// supplemenatry views
typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HomeDefaultHeaderView>
typealias PlaygroundNewsFooterRegistration = UICollectionView.SupplementaryRegistration<PlaygroundNewsFooterView>

