//
//  DeepLinkParserTests.swift
//  RootFeatureTests
//
//  Created by sejin on 12/31/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import XCTest

import BaseFeatureDependency
@testable import RootFeature

final class DeepLinkParserTests: XCTestCase {
    private var parser: DeepLinkParser!
    
    override func setUp() {
        super.setUp()
        self.parser = DeepLinkParser()
    }
    
    override func tearDown() {
        super.tearDown()
        self.parser = nil
    }
    
    func test_URL_형태의_링크가_아닌_경우를_파싱한다() {
        // Given
        let link = "FAIL https:///test/url"
        let expected: DeepLinkData = ([HomeDeepLink()], nil)
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        
        // Then
        XCTAssertTrue(expected.deepLinks[0].name == result.deepLinks[0].name)
        XCTAssertNil(result.queryItems)
    }
    
    func test_만료된_딥링크를_파싱한다() {
        // Given
        let link = "home?expiredAt=2023-01-01T00:00:00.000Z"
        
        // When
        XCTAssertThrowsError(try parser.parse(with: link)) { error in
            // Then
            XCTAssertTrue(error is NotificationLinkError)
            
            if let linkError = error as? NotificationLinkError {
                XCTAssertTrue(linkError == .expiredLink)
            }
        }
    }
    
    func test_쿼리_1개를_파싱한다() {
        // Given
        let link = "home?id=123"
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        
        // Then
        XCTAssertEqual(result.queryItems?.count, 1)
        XCTAssertTrue(result.queryItems?.getQueryValue(key: "id") == "123")
    }
    
    func test_쿼리_2개를_파싱한다() {
        // Given
        let link = "home?id=123&status=active"
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        
        // Then
        XCTAssertEqual(result.queryItems?.count, 2)
        XCTAssertTrue(result.queryItems?.getQueryValue(key: "id") == "123")
        XCTAssertTrue(result.queryItems?.getQueryValue(key: "status") == "active")
    }
    
    func test_잘못된_루트_딥링크인_경우를_파싱한다() {
        // Given
        let link = "none"
        
        // When
        XCTAssertThrowsError(try parser.parse(with: link)) { error in
            // Then
            XCTAssertTrue(error is NotificationLinkError)
            
            if let linkError = error as? NotificationLinkError {
                XCTAssertTrue(linkError == .linkNotFound)
            }
        }
    }
    
    func test_정의되지_않은_path인_경우를_파싱한다() {
        // Given
        let link = "home/none"
        
        // When
        XCTAssertThrowsError(try parser.parse(with: link)) { error in
            // Then
            XCTAssertTrue(error is NotificationLinkError)
            
            if let linkError = error as? NotificationLinkError {
                XCTAssertTrue(linkError == .linkNotFound)
            }
        }
    }
    
    func test_알림_리스트_딥링크를_파싱한다() {
        // Given
        let link = "home/notification"
        let expected = ["home", "notification"]
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_알림_디테일_딥링크를_파싱한다() {
        // Given
        let link = "home/notification/detail?id=1234"
        let expected = ["home", "notification", "detail"]

        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
        XCTAssertEqual(result.queryItems?.count, 1)
        XCTAssertTrue(result.queryItems?.getQueryValue(key: "id") == "1234")
    }
    
    func test_마이페이지_딥링크를_파싱한다() {
        // Given
        let link = "home/mypage"
        let expected = ["home", "mypage"]

        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_출석_딥링크를_파싱한다() {
        // Given
        let link = "home/attendance"
        let expected = ["home", "attendance"]

        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_출석하기_모달_딥링크를_파싱한다() {
        // Given
        let link = "home/attendance/attendance-modal?subLecturedId=1&round=2"
        let expected = ["home", "attendance", "attendance-modal"]
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_솝탬프_전체미션_딥링크를_파싱한다() {
        // Given
        let link = "home/soptamp"
        let expected = ["home", "soptamp"]
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_솝탬프_전체랭킹_딥링크를_파싱한다() {
        // Given
        let link = "home/soptamp/entire-ranking"
        let expected = ["home", "soptamp", "entire-ranking"]
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_콕찌르기_알림리스트_딥링크를_파싱한다() {
        // Given
        let link = "home/poke/notification-list"
        let expected = ["home", "poke", "notification-list"]
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }

        // Then
        XCTAssertEqual(deepLinks, expected)
    }
    
    func test_솝탬프_현재기수_랭킹_딥링크를_파싱한다() {
        // Given
        let link = "home/soptamp/current-generation-ranking?currentGeneration=33&status=active"
        let expected = ["home", "soptamp", "current-generation-ranking"]
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks.map { $0.name }
        let queryItems = result.queryItems

        // Then
        XCTAssertEqual(deepLinks, expected)
        XCTAssertEqual(queryItems?.count, 2)
        XCTAssertEqual(queryItems?.getQueryValue(key: "currentGeneration"), "33")
        XCTAssertEqual(queryItems?.getQueryValue(key: "status"), "active")
    }
    
    func test_딥링크_파싱_종착지뷰_설정을_파싱한다() {
        // Given
        let link = "home/notification"
        let expected = true
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks

        // Then
        guard let lastDeepLink = deepLinks.last else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(expected, lastDeepLink.isDestination)
    }
    
    func test_딥링크_파싱_경유지뷰_설정을_파싱한다() {
        // Given
        let link = "home/notification"
        let expected = false
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        let deepLinks = result.deepLinks

        // Then
        guard let firstDeepLink = deepLinks.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(expected, firstDeepLink.isDestination)
    }
}
