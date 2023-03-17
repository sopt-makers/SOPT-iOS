//
//  StampViewRepresentable.swift
//  StampFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol StampViewRepresentable: ViewRepresentable { }

public protocol StampViewBuilable {
    func makeStampView() -> StampViewRepresentable
}
