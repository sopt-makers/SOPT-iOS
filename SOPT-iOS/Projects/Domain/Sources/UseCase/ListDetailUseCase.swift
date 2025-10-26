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
    func clap(stampId: Int, clapCount: Int)
    
    var listDetailModel: PassthroughSubject<ListDetailModel, Error> { get set }
    var mediaUploadCompleted: PassthroughSubject<Void, Error> { get set }
    var presignedURL: PassthroughSubject<PresignedUrlModel, Error> { get set }
    var editSuccess: PassthroughSubject<Bool, Error> { get set }
    var deleteSuccess: PassthroughSubject<Bool, Error> { get set }
    var clapSuccess: PassthroughSubject<ClapCountModel, Error> { get set }
}

public class DefaultListDetailUseCase {
    
    private let repository: ListDetailRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var listDetailModel = PassthroughSubject<ListDetailModel, Error>()
    public var presignedURL = PassthroughSubject<PresignedUrlModel, Error>()
    public var mediaUploadCompleted = PassthroughSubject<Void, Error>()
    public var editSuccess = PassthroughSubject<Bool, Error>()
    public var deleteSuccess = PassthroughSubject<Bool, Error>()
    public var clapSuccess = PassthroughSubject<ClapCountModel, Error>()
    
    public init(repository: ListDetailRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultListDetailUseCase: ListDetailUseCase {
    public func fetchListDetail(missionId: Int, username: String?) {
        repository.fetchListDetail(missionId: missionId, username: username)
            .withUnretained(self)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { owner, model in
                owner.listDetailModel.send(model)
            })
            .store(in: self.cancelBag)
    }
    
    public func getPresignedURL() {
        self.repository.getPresignedURL()
            .withUnretained(self)
            .sink(receiveCompletion: {
                print("completion: \($0)")
            }, receiveValue: { owner, presignedModel in
                owner.presignedURL.send(presignedModel)
            }).store(in: self.cancelBag)
    }
    
    public func uploadMedia(imageData: Data, presignedUrl: String) {
        self.repository
            .uploadMedia(imageData: imageData, presignedUrl: presignedUrl)
            .withUnretained(self)
            .sink(receiveCompletion: {
                print("completion: \($0)")
            }, receiveValue: { owner, _ in
                owner.mediaUploadCompleted.send(())
                print("receivedValue: \(owner)")
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
                    activityDate: "",
                    clapCount: 0,
                    myClapCount: 0,
                    viewCount: 0,
                    isMine: false
                )
            )
            .withUnretained(self)
            .sink { event in
                print("completion: \(event)")
            } receiveValue: { owner, model in
                owner.listDetailModel.send(model)
            }.store(in: self.cancelBag)
    }
    
    public func putStamp(stampData: ListDetailRequestModel) {
        repository.putStamp(stampData: stampData)
            .replaceError(with: -1)
            .withUnretained(self)
            .sink { owner, result in
                owner.editSuccess.send(result == -1 ? false: true)
            }.store(in: self.cancelBag)
    }
    
    public func deleteStamp(stampId: Int) {
        repository.deleteStamp(stampId: stampId)
            .replaceError(with: false)
            .withUnretained(self)
            .sink { owner, success in
                owner.deleteSuccess.send(success)
            }.store(in: self.cancelBag)
    }
    
    public func clap(stampId: Int, clapCount: Int) {
        repository.clap(stampId: stampId, clapCount: clapCount)
            .replaceError(
                with: ClapCountModel(
                    stampId: 0,
                    appliedCount: 0,
                    totalClapCount: 0
                )
            )
            .withUnretained(self)
            .sink { event in
                print("completion: \(event)")
            } receiveValue: { owner, model in
                owner.clapSuccess.send(model)
            }.store(in: self.cancelBag)
    }
}
