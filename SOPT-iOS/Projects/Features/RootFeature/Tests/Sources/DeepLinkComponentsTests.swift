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
    
    func test_nil인_데이터로_init을_수행한다() {
        // Given
        let data: DeepLinkData? = nil

        // When
        let deepLinkComponents = DeepLinkComponents(deepLinkData: data)
        
        // Then
        XCTAssertNil(deepLinkComponents)
    }
    
    func test_딥링크_데이터가_존재하는_경우_isEmpty를_검사() {
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
    
    func test_id가_키인_쿼리데이터를_가져온다() {
        // Given
        let expected = "123"
        
        // When
        let result = deepLinkComponents.getQueryItemValue(name: "id")
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_쿼리_배열이_비어있는_경우_id_쿼리찾기() {
        // Given
        let expected: String? = nil
        let deepLinkComponents = DeepLinkComponents(deepLinkData: ([], nil))
        
        // When
        let result = deepLinkComponents.getQueryItemValue(name: "id")
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_찾는_쿼리가_없는_경우에_쿼리아이템을_요청한다() {
        // Given
        let expected: String? = nil
        
        // When
        let result = deepLinkComponents.getQueryItemValue(name: "weirdKey")
        
        // Then
        XCTAssertEqual(expected, result)
    }
    
    func test_새_딥링크_객체를_추가한다() {
        // Given
        let deepLinkComponents = DeepLinkComponents(deepLinkData: ([], nil))

        // When
        deepLinkComponents.addDeepLink(HomeDeepLink())
        
        // Then
        XCTAssertFalse(deepLinkComponents.isEmpty)
    }
    
    func test_딥링크_구현체들을_execute하여_라우팅을_수행한다() {
        // Given
        let coordinator = MockCoordinator()
        let mockDeepLinks: [DeepLinkExecutable] = [MockHomeDeepLink(), MockSoptampDeepLink()]
        let expected = mockDeepLinks.map { $0.name }
        
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
