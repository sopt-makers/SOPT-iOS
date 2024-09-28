//
//  DailySoptuneDeepLink.swift
//  RootFeature
//
//  Created by 강윤서 on 9/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import DailySoptuneFeature

public struct DailySoptuneDeepLink: DeepLinkExecutable {
    public var name = "fortune"
    public var children: [DeepLinkExecutable] = [DailySoptuneWordDeepLink()]
    public var isDestination = false
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? DailySoptuneCoordinator else { return nil }
        
        return nil
    }
}
