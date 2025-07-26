//
//  Injected.swift
//  CoreTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

@propertyWrapper
public class Injected<T> {
    public var wrappedValue: T
    
    public init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}
