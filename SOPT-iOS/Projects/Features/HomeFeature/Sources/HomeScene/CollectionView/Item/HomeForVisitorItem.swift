//
//  HomeForVisitorItem.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

enum HomeForVisitorItem: Hashable {
    case dashBoard(HomePresentationModel.DashBoard)
    case productService(HomePresentationModel.ProductService)
    case appService(HomePresentationModel.AppService)
}
