//
//  MyPageDeepLink.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import AppMyPageFeature
import Core

public struct MyPageDeepLink: DeepLinkExecutable {
    public let name = "mypage"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        let userType = UserDefaultKeyList.Auth.getUserType()
        let myPageCoordinator = coordinator.runMyPageFlow(of: userType)
        return myPageCoordinator
    }
}
