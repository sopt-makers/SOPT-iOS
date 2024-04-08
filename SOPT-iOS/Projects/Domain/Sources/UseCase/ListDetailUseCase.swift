//
//  ListDetailUseCase.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Core

import Combine
import Foundation

public protocol ListDetailUseCase {
  func fetchListDetail(missionId: Int, username: String?)
  func postStamp(stampData: ListDetailRequestModel)
  func putStamp(stampData: ListDetailRequestModel)
  func getPresignedURL()
  func uploadMedia(imageData: Data, presignedUrl: String)
  func deleteStamp(stampId: Int)
  
  var listDetailModel: PassthroughSubject<ListDetailModel, Error> { get set }
  var mediaUploadCompleted: PassthroughSubject<Void, Error> { get set }
  var presignedURL: PassthroughSubject<PresignedUrlModel, Error> { get set }
  var editSuccess: PassthroughSubject<Bool, Error> { get set }
  var deleteSuccess: PassthroughSubject<Bool, Error> { get set }
}

public class DefaultListDetailUseCase {
  
  private let repository: ListDetailRepositoryInterface
  private var cancelBag = CancelBag()
  
  public var listDetailModel = PassthroughSubject<ListDetailModel, Error>()
  public var presignedURL = PassthroughSubject<PresignedUrlModel, Error>()
  public var mediaUploadCompleted = PassthroughSubject<Void, Error>()
  public var editSuccess = PassthroughSubject<Bool, Error>()
  public var deleteSuccess = PassthroughSubject<Bool, Error>()
  
  public init(repository: ListDetailRepositoryInterface) {
    self.repository = repository
  }
}

extension DefaultListDetailUseCase: ListDetailUseCase {
  public func fetchListDetail(missionId: Int, username: String?) {
    repository.fetchListDetail(missionId: missionId, username: username)
      .sink(receiveCompletion: { event in
        print("completion: \(event)")
      }, receiveValue: { model in
        self.listDetailModel.send(model)
      })
      .store(in: self.cancelBag)
  }
  
  public func getPresignedURL() {
    self.repository.getPresignedURL()
      .sink(receiveCompletion: {
        print("completion: \($0)")
      }, receiveValue: { presignedModel in
        self.presignedURL.send(presignedModel)
      }).store(in: self.cancelBag)
  }

  public func uploadMedia(imageData: Data, presignedUrl: String) {
    self.repository
      .uploadMedia(imageData: imageData, presignedUrl: presignedUrl)
      .sink(receiveCompletion: {
        print("completion: \($0)")
      }, receiveValue: {
        self.mediaUploadCompleted.send(())
        print("receivedValue: \($0)")
      }).store(in: self.cancelBag)
  }
  
  public func postStamp(stampData: ListDetailRequestModel) {
    repository.postStamp(stampData: stampData)
      .replaceError(
        with: ListDetailModel(
          image: "",
          content: "",
          date: "",
          stampId: 0,
          activityDate: ""
        )
      )
      .sink { event in
        print("completion: \(event)")
      } receiveValue: { model in
        self.listDetailModel.send(model)
      }.store(in: self.cancelBag)
  }
  
  public func putStamp(stampData: ListDetailRequestModel) {
    repository.putStamp(stampData: stampData)
      .replaceError(with: -1)
      .sink { result in
        self.editSuccess.send(result == -1 ? false: true)
      }.store(in: self.cancelBag)
  }
  
  public func deleteStamp(stampId: Int) {
    repository.deleteStamp(stampId: stampId)
      .replaceError(with: false)
      .sink { success in
        self.deleteSuccess.send(success)
      }.store(in: self.cancelBag)
  }
}
