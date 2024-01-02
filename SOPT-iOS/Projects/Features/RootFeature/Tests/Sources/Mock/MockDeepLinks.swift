//
//  MockDeepLinks.swift
//  RootFeatureTests
//
//  Created by sejin on 1/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

class MockHomeDeepLink: DeepLinkExecutable {
    var name: String = "mockHomeDeepLink"
    var children: [BaseFeatureDependency.DeepLinkExecutable] = []
    var isDestination: Bool = false
    
    func execute(with coordinator: BaseFeatureDependency.Coordinator, queryItems: [URLQueryItem]?) -> BaseFeatureDependency.Coordinator? {
        guard let coordinator = coordinator as? MockCoordinator else { return nil }
        
        coordinator.runMockFlow(viewName: self.name)
        return coordinator
    }
}

class MockSoptampDeepLink: DeepLinkExecutable {
    var name: String = "mockSoptampDeepLink"
    
    var children: [BaseFeatureDependency.DeepLinkExecutable] = []
    var isDestination: Bool = true
    
    func execute(with coordinator: BaseFeatureDependency.Coordinator, queryItems: [URLQueryItem]?) -> BaseFeatureDependency.Coordinator? {
        guard let coordinator = coordinator as? MockCoordinator else { return nil }
        coordinator.runMockFlow(viewName: self.name)
        return coordinator
    }
}
