//
//  SoptlogFeatureBuildable.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol SoptlogFeatureBuildable {
    func makeSoptlog() -> SoptlogPresentable
}
