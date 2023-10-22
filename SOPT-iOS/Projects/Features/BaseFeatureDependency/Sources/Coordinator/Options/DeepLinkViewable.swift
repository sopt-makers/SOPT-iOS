//
//  DeepLinkViewable.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol DeepLinkViewable {
    var name: String { get }
    
    func findChild(name: String) -> DeepLinkViewable?
}
