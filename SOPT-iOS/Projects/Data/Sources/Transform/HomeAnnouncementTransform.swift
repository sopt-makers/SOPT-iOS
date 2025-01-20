//
//  HomeAnnouncementTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeEmploymentEntity {
    public func toDomain() -> HomeAnnouncementModel {
        return HomeAnnouncementModel(id: id, categoryName: categoryName, title: title, profileImage: profileImage, name: name, content: content, images: images)
    }
}
