//
//  ListDetailViewModel.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain

public class ListDetailViewModel: ViewModelType {
  
  private let useCase: ListDetailUseCase
  private var cancelBag = CancelBag()
  public var sceneType: ListDetailSceneType!
  public var starLevel: StarViewLevel!
  public var missionId: Int!
  public var missionTitle: String!
  public var stampId: Int!
  public var isOtherUser: Bool
  public var otherUserName: String!
  
  private var uploadedUrl: String?
  
  // MARK: - Inputs
  
  public struct Input {
    let viewDidLoad: Driver<Void>
    let imageSelected: Driver<Data>
    let bottomButtonTapped: Driver<ListDetailRequestModel>
    let rightButtonTapped: Driver<ListDetailSceneType>
    let deleteButtonTapped: Driver<Bool>
  }
  
  // MARK: - Outputs
  
  public class Output {
    @Published var listDetailModel: ListDetailModel?
    var editSuccessed = PassthroughSubject<Bool, Never>()
    var showDeleteAlert = PassthroughSubject<Bool, Never>()
    var deleteSuccessed = PassthroughSubject<Bool, Never>()
  }
  
  // MARK: - init
  
  public init(
    useCase: ListDetailUseCase,
    sceneType: ListDetailSceneType,
    starLevel: StarViewLevel,
    missionId: Int,
    missionTitle: String,
    otherUsername: String?
  ) {
    self.useCase = useCase
    self.sceneType = sceneType
    self.starLevel = starLevel
    self.missionId = missionId
    self.missionTitle = missionTitle
    self.isOtherUser = !(otherUsername == nil)
    self.otherUserName = otherUsername
  }
}

extension ListDetailViewModel {
  public func transform(from input: Input, cancelBag: CancelBag) -> Output {
    let output = Output()
    self.bindOutput(output: output, cancelBag: cancelBag)
    
    input.viewDidLoad
      .withUnretained(self)
      .filter { owner, _ in
        owner.sceneType == .completed
      }
      .sink { owner, _ in
        owner.isOtherUser
        ? owner.useCase.fetchListDetail(missionId: owner.missionId, username: owner.otherUserName)
        : owner.useCase.fetchListDetail(missionId: owner.missionId, username: nil)
      }.store(in: cancelBag)
    
    input.imageSelected
      .flatMap { [weak self] imageData -> Driver<(Data, PresignedUrlModel)> in
        guard let self else { return .empty() }
        
        self.useCase.getPresignedURL()
        
        return self.useCase
          .presignedURL
          .map { (imageData, $0) }
          .eraseToAnyPublisher()
          .asDriver()
      }
      .flatMap { [weak self] imageData, presignedUrlModel -> Driver<Void> in
        guard let self else { return .empty() }
        
        self.uploadedUrl = presignedUrlModel.imageURL
        self.useCase.uploadMedia(imageData: imageData, presignedUrl: presignedUrlModel.preSignedURL)
        
        return self.useCase
          .mediaUploadCompleted
          .eraseToAnyPublisher()
          .asDriver()
      }
      .sink(receiveValue: { value in
        
      }).store(in: self.cancelBag)
    
    input.bottomButtonTapped
      .eraseToAnyPublisher()
      .flatMap { [weak self] requestModel -> Driver<ListDetailRequestModel> in
        guard
          let self,
          let presignedUrl = self.uploadedUrl?.removePercentEncodingIfNeeded()
        else { return .empty() }
        
        var requestModel = requestModel
        return Just(requestModel.updateImgUrl(to: presignedUrl)).asDriver()
      }
      .sink { requestModel in
        if self.sceneType == ListDetailSceneType.none {
          self.useCase.postStamp(stampData: requestModel)
        } else {
          self.useCase.putStamp(stampData: requestModel)
        }
      }.store(in: self.cancelBag)
    
    input.rightButtonTapped
      .sink { sceneType in
        switch sceneType {
        case .completed:
          output.showDeleteAlert.send(false)
        case .edit:
          output.showDeleteAlert.send(true)
        default:
          break
        }
      }.store(in: self.cancelBag)
    
    input.deleteButtonTapped
      .sink { _ in
        self.useCase.deleteStamp(stampId: self.stampId)
      }.store(in: self.cancelBag)
    
    return output
  }
  
  private func bindOutput(output: Output, cancelBag: CancelBag) {
    let listDetailModel = useCase.listDetailModel
    let editSuccess = useCase.editSuccess
    let deleteSuccess = useCase.deleteSuccess
    
    listDetailModel.asDriver()
      .compactMap {
        self.stampId = $0.stampId
        return $0
      }
      .assign(to: \.self.listDetailModel, on: output)
      .store(in: self.cancelBag)
    
    editSuccess.asDriver()
      .sink { success in
        output.editSuccessed.send(success)
      }.store(in: self.cancelBag)
    
    deleteSuccess.asDriver()
      .sink { success in
        output.deleteSuccessed.send(success)
      }.store(in: self.cancelBag)
  }
}
