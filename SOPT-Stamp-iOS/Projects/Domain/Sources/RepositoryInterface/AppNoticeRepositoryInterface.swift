//
//  AppNoticeRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol AppNoticeRepositoryInterface {
    func getAppNotice() -> AnyPublisher<AppNoticeModel, Error>
}
