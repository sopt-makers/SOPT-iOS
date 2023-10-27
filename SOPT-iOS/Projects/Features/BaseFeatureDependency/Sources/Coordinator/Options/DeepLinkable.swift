//
//  DeepLinkable.swift
//  RootFeature
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol DeepLinkable {
    func execute(with coordinator: Coordinator, components: DeepLinkComponentsExecutable)
}

public typealias DeepLinkData = (deepLinks: [DeepLinkable], queryItems: [URLQueryItem]?)
