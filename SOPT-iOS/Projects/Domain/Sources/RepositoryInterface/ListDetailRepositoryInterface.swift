//
//  ListDetailRepositoryInterface.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Core

import Combine

public protocol ListDetailRepositoryInterface {
    func fetchListDetail(missionId: Int, username: String?) -> AnyPublisher<ListDetailModel, Error>
    func postStamp(missionId: Int, stampData: [Any]) -> AnyPublisher<ListDetailModel, Error>
    func putStamp(missionId: Int, stampData: [Any]) -> Driver<Int>
    func deleteStamp(stampId: Int) -> Driver<Bool>
}
