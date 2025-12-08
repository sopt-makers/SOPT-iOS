//
//  SoptlogRepositoryInterface.swift
//  Domain
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol SoptlogRepositoryInterface {
    func fetchSoptlogModel() async throws -> SoptlogModel
}
