//
//  DailySoptuneWordDeepLink.swift
//  DailySoptuneFeatureDemo
//
//  Created by 강윤서 on 9/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct DailySoptuneWordDeepLink: DeepLinkExecutable {
    public var name = "word"
    public var children: [DeepLinkExecutable] = []
    public var isDestination = true
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? DailySoptuneCoordinator else { return nil }
        
        if self.isDestination == true {
            coordinator.start()
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
}
