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
    func fetchListDetail(missionId: Int) -> Driver<ListDetailModel>
    func postStamp(missionId: Int, stampData: [Any]) -> Driver<ListDetailModel>
    func putStamp(missionId: Int, stampData: [Any]) -> Driver<Int>
    func deleteStamp(stampId: Int) -> Driver<Bool>
}
