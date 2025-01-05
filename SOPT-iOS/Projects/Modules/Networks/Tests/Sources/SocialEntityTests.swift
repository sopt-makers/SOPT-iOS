//
//  SocialEntityTests.swift
//  NetworksTests
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import XCTest
@testable import Networks

final class SocialEntityTests: XCTestCase {

    override func setUp()  {
    }

    override func tearDown() {
    }

    func test_changeSocialEntity의_authPlatform가_enum의_RAW값으로_encode되는가() throws {
        
        // given
        let encoder = JSONEncoder()
        let entity = ChangeSocialAccountEntity(phone: "", authPlatform: .apple, code: "")
        
        // when
        let data = try encoder.encode(entity)
        let jsonString = String(data: data, encoding: .utf8)
        
        //then
        XCTAssertTrue(jsonString!.contains("\"authPlatform\":\"APPLE\""), "authPlatform 값이 올바르게 인코딩되지 않았습니다.")
        
    }


}
