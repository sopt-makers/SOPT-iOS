//
//  DeepLinkExecutable.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol DeepLinkTreeNode {
    var name: String { get }
    var children: [DeepLinkExecutable] { get }
    var isDestination: Bool { get set }
    func findChild(name: String) -> DeepLinkExecutable?
}

public protocol DeepLinkExecutable: DeepLinkTreeNode {
    @discardableResult
    func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator?
}

public extension DeepLinkExecutable {
    func findChild(name: String) -> DeepLinkExecutable? {
        return children.first(where: { $0.name == name })
    }
}

public typealias DeepLinkData = (deepLinks: [DeepLinkExecutable], queryItems: [URLQueryItem]?)
