//
//  MockMainUseCase.swift
//  MainFeatureDemo
//
//  Created by sejin on 2023/07/05.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Domain
import Core

final class MockMainUseCase: MainUseCase {
    var userMainInfo = PassthroughSubject<Domain.UserMainInfoModel?, Never>()
    
    var mainErrorOccurred = PassthroughSubject<Domain.MainError, Never>()
    
    func getUserMainInfo() {
        self.userMainInfo.send(UserMainInfoModel.dummyUserInfoModel[0])
    }
}
