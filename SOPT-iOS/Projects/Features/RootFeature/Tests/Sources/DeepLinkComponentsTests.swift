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
    
    override func setUp() {
        super.setUp()
        self.deepLinkComponents = DeepLinkComponents(deepLinkData: self.mockDeepLinkData)
    }
    
    override func tearDown() {
        super.tearDown()
        self.deepLinkComponents = nil
    }
    
    func test_failable_initializer() {
        // Given
        let data: DeepLinkData? = nil

        // When
        let deepLinkComponents = DeepLinkComponents(deepLinkData: data)
        
        // Then
        XCTAssertNil(deepLinkComponents)
    }
    
    func test_isEmpty() {
        // Given
        let expected = false
        
        // When
        let result = deepLinkComponents.isEmpty
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_isEmpty_빈_딥링크_배열인_경우() {
        // Given
        let expected = true
        let deepLinkComponents = DeepLinkComponents(deepLinkData: ([], nil))
        
        // When
        let result = deepLinkComponents.isEmpty
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_queryItems_할당() {
        // Given
        let expected = self.mockDeepLinkData.queryItems
        
        // When
        let result = deepLinkComponents.queryItems
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_getQueryItems() {
        // Given
        let expected = "123"
        
        // When
        let result = deepLinkComponents.getQueryItemValue(name: "id")
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_addDeepLink() {
        // Given
        let deepLinkComponents = DeepLinkComponents(deepLinkData: ([], nil))

        // When
        deepLinkComponents.addDeepLink(HomeDeepLink())
        
        // Then
        XCTAssertFalse(deepLinkComponents.isEmpty)
    }
    
    func test_execute() {
        // Given
        let coordinator = MockCoordinator()
        let mockDeepLinks: [DeepLinkExecutable] = [MockHomeDeepLink(), MockSoptampDeepLink()]
        let expected = mockDeepLinks.map { $0.name }
        // home은 경로일 때는 라우팅하지 않는다.
        
        // When
        let deepLinkComponents = DeepLinkComponents(deepLinkData: (mockDeepLinks, nil))
        deepLinkComponents.execute(coordinator: coordinator)
        
        // Then
        
        XCTAssertEqual(expected, coordinator.childViewNames)
    }
}

extension DeepLinkComponentsTests {
    private var mockDeepLinkData: DeepLinkData {
        return (deepLinks: [HomeDeepLink(), NotificationDeepLink()], queryItems: [URLQueryItem(name: "id", value: "123"), URLQueryItem(name: "status", value: "active")])
    }
}
