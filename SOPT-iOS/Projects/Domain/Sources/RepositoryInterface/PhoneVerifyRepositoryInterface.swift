//
//  PhoneVerifyRepositoryInterface.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PhoneVerifyRepositoryInterface {
    func send(_ model: PhoneSendModel) -> AnyPublisher<Void, PhoneVerifyError>
    func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, PhoneVerifyError>
}
