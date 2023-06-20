//
//  MyPageFeatureBuildable.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol MyPageFeatureBuildable {
    func makeAppMyPage(userType: UserType) -> MyPagePresentable
}
