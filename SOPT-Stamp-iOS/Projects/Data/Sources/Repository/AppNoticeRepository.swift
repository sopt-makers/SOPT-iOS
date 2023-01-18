//
//  AppNoticeRepository.swift
//  Data
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class AppNoticeRepository {
    
    private let rankService: RankService
    private let cancelBag = CancelBag()
    
    public init(service: RankService) {
        self.rankService = service
    }
}

extension AppNoticeRepository: AppNoticeRepositoryInterface {

}
