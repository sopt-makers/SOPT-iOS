//
//  SoptletterService.swift
//  Networks
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya

public typealias DefaultSoptletterService = BaseService<SoptletterAPI>

public protocol SoptletterService {
    func writeMessage(topicId: Int, content: String) -> AnyPublisher<Int, Error>
}

extension DefaultSoptletterService: SoptletterService {
    public func writeMessage(topicId: Int, content: String) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.writeMessage(topicId: topicId, content: content))
    }
}
