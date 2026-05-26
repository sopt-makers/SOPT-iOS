//
//  DeepLinkComponentsExecutable.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/10/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

public protocol DeepLinkComponentsExecutable {
    var queryItems: [URLQueryItem]? { get }
    var isEmpty: Bool { get }
    var targetTap: TabBarItemType? { get }
    func execute(coordinator: Coordinator)
    func addDeepLink(_ deepLink: DeepLinkExecutable)
    func getQueryItemValue(name: String) -> String?
}
