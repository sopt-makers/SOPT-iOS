//
//  PostDisplayable.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 6/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

/// Post cell 관련 모델에서 쓰이는 공통 프로토콜입니다.
protocol PostDisplayable {
    var profileImage: String? { get }
    var name: String? { get }
    var generationAndPart: String? { get }
    var category: String { get }
    var title: String { get }
    var content: String { get }
    var webLink: String { get }
    var id: String { get }
    var postID: Int? { get }
    var userID: Int? { get }
    var ranking: Int? { get }
}
