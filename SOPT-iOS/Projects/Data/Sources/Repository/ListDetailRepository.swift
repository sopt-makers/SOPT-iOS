//
//  ListDetailRepository.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain
import Networks

public class ListDetailRepository {
  
  private let stampService: StampService
  private let s3Service: S3Service
  private let mediaService: MediaService
  
  private let cancelBag = CancelBag()
  
  public init(
    stampService: StampService,
    s3Service: S3Service,
    mediaService: MediaService
  ) {
    self.stampService = stampService
    self.s3Service = s3Service
    self.mediaService = mediaService
  }
}

extension ListDetailRepository: ListDetailRepositoryInterface {
  public func fetchListDetail(missionId: Int, username: String?) -> AnyPublisher<ListDetailModel, Error> {
    let username = username ?? UserDefaultKeyList.User.soptampName
    guard let username else {
      return Fail(error: NSError()).eraseToAnyPublisher()
    }
    return stampService.fetchStampListDetail(missionId: missionId, username: username)
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  public func getPresignedURL() -> AnyPublisher<PresignedUrlModel, Error> {
    return s3Service.getPresignedUrl()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  public func uploadMedia(imageData: Data, presignedUrl: String) -> AnyPublisher<Void, Error> {
    return mediaService.uploadMedia(imageData: imageData, to: presignedUrl)
      .eraseToAnyPublisher()
  }
  
  public func postStamp(stampData: ListDetailRequestModel) -> AnyPublisher<ListDetailModel, Error> {
    return stampService.postStamp(requestModel: stampData)
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  public func putStamp(stampData: ListDetailRequestModel) -> Driver<Int> {
    return stampService.putStamp(requestModel: stampData)
      .map { $0.toDomain() }
      .asDriver()
  }
  
  public func deleteStamp(stampId: Int) -> Driver<Bool> {
    return stampService.deleteStamp(stampId: stampId)
      .map { $0 == 200 }
      .asDriver()
  }
}
