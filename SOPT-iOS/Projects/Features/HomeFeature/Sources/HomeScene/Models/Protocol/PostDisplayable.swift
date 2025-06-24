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
    var title: String { get }
    var category: String { get }
    var profileImage: String? { get }
    var name: String? { get }
    var content: String { get }
    var isHotPost: Bool { get }
}
