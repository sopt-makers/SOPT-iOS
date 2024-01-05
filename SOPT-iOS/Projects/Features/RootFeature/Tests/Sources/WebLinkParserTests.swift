//
//  WebLinkParserTests.swift
//  RootFeatureTests
//
//  Created by sejin on 12/31/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import XCTest

@testable import RootFeature

final class WebLinkParserTests: XCTestCase {
    private var parser: WebLinkParser!
    
    override func setUp() {
        super.setUp()
        self.parser = WebLinkParser()
    }
    
    override func tearDown() {
        super.tearDown()
        self.parser = nil
    }
    
    func test_URL_형태의_링크가_아닌_경우를_파싱한다() {
        // Given
        let link = "FAIL https:///test/url"
        
        // When
        XCTAssertThrowsError(try parser.parse(with: link)) { error in
            // Then
            XCTAssertTrue(error is NotificationLinkError)
            
            if let linkError = error as? NotificationLinkError {
                XCTAssertTrue(linkError == .invalidLink)
            }
        }
    }
    
    func test_잘못된_Scheme의_링크인_경우를_파싱한다() {
        // Given
        let link = "none://test/url"
        
        // When
        XCTAssertThrowsError(try parser.parse(with: link)) { error in
            // Then
            XCTAssertTrue(error is NotificationLinkError)
            
            if let linkError = error as? NotificationLinkError {
                XCTAssertTrue(linkError == .invalidScheme)
            }
        }
    }
    
    func test_만료된_링크를_파싱한다() {
        // Given
        let link = "https://www.sopt.org?expiredAt=2023-01-01T00:00:00.000Z"
        
        // When
        XCTAssertThrowsError(try parser.parse(with: link)) { error in
            // Then
            XCTAssertTrue(error is NotificationLinkError)
            
            if let linkError = error as? NotificationLinkError {
                XCTAssertTrue(linkError == .expiredLink)
            }
        }
    }
    
    func test_만료기간이_있지만_아직_만료되지_않은_경우를_파싱한다() {
        // Given
        let link = "https://www.sopt.org?expiredAt=2099-01-01T00:00:00.000Z"
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        
        // Then
        XCTAssertNoThrow(try parser.parse(with: link))
        XCTAssertEqual(result, link)
    }
    
    func test_https_스킴의_정상적인_링크를_파싱한다() {
        // Given
        let link = "https://www.sopt.org"
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        
        // Then
        XCTAssertEqual(result, link)
    }
    
    func test_http_스킴의_정상적인_링크를_파싱한다() {
        // Given
        let link = "http://www.sopt.org"
        
        // When
        guard let result = try? parser.parse(with: link) else { return XCTFail() }
        
        // Then
        XCTAssertEqual(result, link)
    }
}
