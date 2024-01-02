//
//  DeepLinkComponentsTests.swift
//  RootFeatureTests
//
//  Created by sejin on 1/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import XCTest
import Combine

import BaseFeatureDependency
@testable import RootFeature

final class DeepLinkComponentsTests: XCTestCase {
    private var deepLinkComponents: DeepLinkComponents!
    private var subsriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
//        self.deepLinkComponents = DeepLinkComponents(deepLinkData: <#DeepLinkData?#>)
    }
    
    override func tearDown() {
        super.tearDown()
        self.deepLinkComponents = nil
        self.subsriptions = []
    }
}
