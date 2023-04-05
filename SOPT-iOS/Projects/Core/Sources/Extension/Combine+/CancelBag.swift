//
//  CancelBag.swift
//  Core
//
//  Created by Junho Lee on 2022/10/25.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

open class CancelBag {
    public var subscriptions = Set<AnyCancellable>()
    
    public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    public init() { }
}

extension AnyCancellable {
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
