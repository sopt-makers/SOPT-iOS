//
//  HomeItemRegistrationTypes.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

// cells
typealias DashBoardCardCellRegistration = UICollectionView.CellRegistration<DashBoardCardCVC, HomePresentationModel.Description>
typealias CalendarCellRegistration = UICollectionView.CellRegistration<CalendarCardCVC, HomePresentationModel.RecentSchedule>
typealias ProductCellRegistration = UICollectionView.CellRegistration<MainProductCardCVC, HomePresentationModel.ProductService>
typealias AppServiceCellRegistration = UICollectionView.CellRegistration<AppServiceCardCVC, HomePresentationModel.AppService>
typealias InsightCellRegistration = UICollectionView.CellRegistration<InsightCardCVC, HomePresentationModel.InsightPost>
typealias GroupCellRegistration = UICollectionView.CellRegistration<GroupCardCVC, HomePresentationModel.GroupPost>
typealias CoffeeChatCellRegistration = UICollectionView.CellRegistration<CoffeeChatCardCVC, HomePresentationModel.CoffeeChat>
typealias AnnouncementCellRegistration = UICollectionView.CellRegistration<AnnouncementCardCVC, HomePresentationModel.Announcement>
typealias SocialLinkCellRegistration = UICollectionView.CellRegistration<SocialLinkCardCVC, SocialLinkCardType>

// supplemenatry views
typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HomeDefaultHeaderView>
typealias FooterRegistration = UICollectionView.SupplementaryRegistration<AnnouncementPageContolFooterView>
