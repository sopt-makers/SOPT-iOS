//
//  MyPageItem.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

struct MyPageItem: Hashable {
    let id = UUID()
    let title: String
    let hasArrow: Bool = true
}
