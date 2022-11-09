//
//  SampleRepository.swift
//  Network
//
//  Created by Junho Lee on 2022/11/09.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Domain
import Network

public class SampleRepository {
    
    private let networkService: NoticeService
    private let cancelBag = Set<AnyCancellable>()
    
    public init(service: NoticeService) {
        self.networkService = service
    }
}

extension SampleRepository: SampleRepositoryInterface {
    
}
