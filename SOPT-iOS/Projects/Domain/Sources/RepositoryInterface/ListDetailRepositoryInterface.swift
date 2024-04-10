//
//  ListDetailRepositoryInterface.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Core

import Combine
import Foundation

public protocol ListDetailRepositoryInterface {
  func fetchListDetail(missionId: Int, username: String?) -> AnyPublisher<ListDetailModel, Error>
  func getPresignedURL() -> AnyPublisher<PresignedUrlModel, Error>
  func uploadMedia(imageData: Data, presignedUrl: String) -> AnyPublisher<Void, Error>
  func postStamp(stampData: ListDetailRequestModel) -> AnyPublisher<ListDetailModel, Error>
  func putStamp(stampData: ListDetailRequestModel) -> Driver<Int>
  func deleteStamp(stampId: Int) -> Driver<Bool>
}
