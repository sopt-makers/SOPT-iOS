//
//  NotificationHandlerTests.swift
//  RootFeatureTests
//
//  Created by sejin on 1/1/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import XCTest
import Combine

import BaseFeatureDependency
@testable import RootFeature

final class NotificationHandlerTests: XCTestCase {
    private var notificationHandler: NotificationHandler!
    private var subsriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        self.notificationHandler = NotificationHandler()
    }
    
    override func tearDown() {
        super.tearDown()
        self.notificationHandler = nil
        self.subsriptions = []
    }
    
    func test_receive_deepLink() {
        // Given
        let link = "home/notification"
        var result: DeepLinkComponentsExecutable!
        
        notificationHandler
            .deepLink
            .dropFirst()
            .sink { components in
                result = components
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(deepLink: link)
        
        // Then
        XCTAssertTrue(result is DeepLinkComponents)
    }
    
    func test_receive_deepLink_파싱성공() {
        // Given
        let link = "home/notification"
        var result: DeepLinkComponents!
        
        notificationHandler
            .deepLink
            .dropFirst()
            .compactMap { $0 as? DeepLinkComponents }
            .sink { components in
                result = components
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(deepLink: link)
        
        // Then
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_receive_deepLink_파싱실패() {
        // Given
        let link = "none"
        var linkError: NotificationLinkError!
        
        notificationHandler
            .notificationLinkError
            .compactMap { $0 }
            .sink { error in
                linkError = error
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(deepLink: link)
        
        // Then
        XCTAssertTrue(linkError == .linkNotFound)
    }
    
    func test_receive_deepLink_만료된_링크() {
        // Given
        let link = "home?expiredAt=2023-01-01T00:00:00.000Z"
        var linkError: NotificationLinkError!
        
        notificationHandler
            .notificationLinkError
            .compactMap { $0 }
            .sink { error in
                linkError = error
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(deepLink: link)
        
        // Then
        XCTAssertTrue(linkError == .expiredLink)
    }
    
    func test_receive_webLink() {
        // Given
        let link = "https://www.sopt.org"
        var result = ""
        
        notificationHandler
            .webLink
            .compactMap { $0 }
            .sink { link in
                result = link
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(webLink: link)
        
        // Then
        XCTAssertEqual(result, link)
    }
    
    func test_receive_webLink_파싱실패_잘못된_URL() {
        // Given
        let link = "FAIL https:///test/url"
        var linkError: NotificationLinkError!

        notificationHandler
            .notificationLinkError
            .compactMap { $0 }
            .sink { error in
                linkError = error
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(webLink: link)
        
        // Then
        XCTAssertTrue(linkError == .invalidLink)
    }
    
    func test_receive_webLink_파싱실패_잘못된_Scheme() {
        // Given
        let link = "none://test/url"
        var linkError: NotificationLinkError!

        notificationHandler
            .notificationLinkError
            .compactMap { $0 }
            .sink { error in
                linkError = error
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(webLink: link)
        
        // Then
        XCTAssertTrue(linkError == .invalidScheme)
    }
    
    func test_receive_webLink_파싱실패_만료된_링크() {
        // Given
        let link = "https://www.sopt.org?expiredAt=2023-01-01T00:00:00.000Z"
        var linkError: NotificationLinkError!

        notificationHandler
            .notificationLinkError
            .compactMap { $0 }
            .sink { error in
                linkError = error
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(webLink: link)
        
        // Then
        XCTAssertTrue(linkError == .expiredLink)
    }
    
    func test_clear_record() {
        // Given
        let deepLink = "home/notification"
        let webLink = "https://www.sopt.org"
        var linkError: NotificationLinkError?
        var deepLinkResult: DeepLinkComponentsExecutable?
        var webLinkResult: String? = ""

        notificationHandler
            .deepLink
            .sink { components in
                deepLinkResult = components
            }.store(in: &subsriptions)

        notificationHandler
            .notificationLinkError
            .sink { error in
                linkError = error
            }.store(in: &subsriptions)
        
        notificationHandler
            .webLink
            .sink { link in
                webLinkResult = link
            }.store(in: &subsriptions)
        
        // When
        notificationHandler.receive(deepLink: deepLink)
        notificationHandler.receive(webLink: webLink)
        notificationHandler.clearNotificationRecord()

        // Then
        XCTAssertNil(linkError)
        XCTAssertNil(deepLinkResult)
        XCTAssertNil(webLinkResult)
    }
}
