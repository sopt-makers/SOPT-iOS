//
//  XCUIElement+.swift
//  TestCore
//
//  Created by Junho Lee on 2023/06/09.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import XCTest

public extension XCUIElement {
    func tapIfExist() {
        if self.exists {
            self.tap()
        }
    }
}
