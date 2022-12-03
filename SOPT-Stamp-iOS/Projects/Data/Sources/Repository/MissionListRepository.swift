//
//  MissionListRepository.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Domain
import Network

public class MissionListRepository {
    
    private let networkService: NoticeService
    private let cancelBag = Set<AnyCancellable>()
    
    public init(service: NoticeService) {
        self.networkService = service
    }
}

extension MissionListRepository: MissionListRepositoryInterface {
    
}
