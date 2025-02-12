//
//  HomeForVisitorItem.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

enum HomeForVisitorItem: Hashable {
    case description(HomePresentationModel.Description)
    case productService(HomePresentationModel.ProductService)
    case appService(HomePresentationModel.AppService)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .description(let model):
            hasher.combine(model.id.hashValue)
        case .productService(let model):
            hasher.combine(model.id.hashValue)
        case .appService(let model):
            hasher.combine(model.id.hashValue)
        }
    }
}
