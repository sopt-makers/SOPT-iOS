//
//  NotificationPayloadTests.swift
//  RootFeatureTests
//
//  Created by sejin on 12/31/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import XCTest

@testable import RootFeature

final class NotificationPayloadTests: XCTestCase {
    private var payload: NotificationPayload!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        self.payload = nil
    }
    
    private func loadMockPayload(resource: String) {
        guard let path = Bundle(for: NotificationPayloadTests.self).path(forResource: resource, ofType: "json")  else { return }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyHashable: Any] {
                    self.payload = NotificationPayload(dictionary: jsonDict)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
    }
    
    func test_payload_decoding() {
        // Given
        let mockJson = "MockDeepLinkPayload"
        
        // When
        self.loadMockPayload(resource: mockJson)
        
        // Then
        XCTAssertEqual(payload.id, "2133")
        XCTAssertEqual(payload.deepLink, "home/soptamp/entire-ranking")
        XCTAssertEqual(payload.category, "NOTICE")
        XCTAssertEqual(payload.aps.alert.title, "테스트")
        XCTAssertEqual(payload.aps.alert.body, "안녕하세요")
    }
    
    func test_payload_decoding_실패() {
        // Given
        let dictionary: [AnyHashable: Any] = ["none": "willFail"]
        
        // When
        self.payload = NotificationPayload(dictionary: dictionary)
        
        // Then
        XCTAssertNil(self.payload)
    }
    
    func test_hasLink() {
        // Given
        let mockJson = "MockDeepLinkPayload"

        // When
        self.loadMockPayload(resource: mockJson)
        
        // Then
        XCTAssertTrue(payload.hasLink)
    }
    
    func test_hasDeepLink_딥링크만_있는_경우() {
        // Given
        let mockJson = "MockDeepLinkPayload"

        // When
        self.loadMockPayload(resource: mockJson)
        
        // Then
        XCTAssertTrue(payload.hasDeepLink)
    }
    
    func test_hasDeepLink_웹링크만_있는_경우() {
        // Given
        let mockJson = "MockWebLinkPayload"

        // When
        self.loadMockPayload(resource: mockJson)
        
        // Then
        XCTAssertFalse(payload.hasDeepLink)
    }
    
    func test_hasWebLink_딥링크만_있는_경우() {
        // Given
        let mockJson = "MockDeepLinkPayload"

        // When
        self.loadMockPayload(resource: mockJson)
        
        // Then
        XCTAssertFalse(payload.hasWebLink)
    }
    
    func test_hasWebLink_웹링크만_있는_경우() {
        // Given
        let mockJson = "MockWebLinkPayload"

        // When
        self.loadMockPayload(resource: mockJson)
        
        // Then
        XCTAssertTrue(payload.hasWebLink)
    }
}
