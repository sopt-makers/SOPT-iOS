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

public class ListDetailViewModel: ListDetailViewModelType {
    
    // MARK: - Trigger
    // TODO: coordinating vc -> vm
    public var onComplete: ((Core.StarViewLevel, (() -> Void)?) -> Void)?
    public var onNaviBackTap: (() -> Void)?
    public var onViewClapTap: ((Int, String) -> Void)?

    // MARK: - Properties
    
    private let useCase: ListDetailUseCase
    private var cancelBag = CancelBag()
    
    public var sceneType: ListDetailSceneType!
    public var starLevel: StarViewLevel!
    public var missionId: Int!
    public var missionTitle: String!
    public var stampId: Int!
    public var isOtherUser: Bool
    public var otherUserName: String!
    public var isAppjam: Bool?

    var totalClapCount: Int = 0
    var myClapCount: Int = 0
    var viewcount: Int = 0
    
    private var uploadedUrl: String?
    
    private let currentImage = CurrentValueSubject<Data, Never>(Data())
    private let currentDate = CurrentValueSubject<String, Never>(String())
    private let currentText = CurrentValueSubject<String, Never>(String())
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let imageSelected: Driver<Data>
        let dateSelected: Driver<String>
        let textEdited: Driver<String>
        let bottomButtonTapped: Driver<Void>
        let rightButtonTapped: Driver<ListDetailSceneType>
        let deleteButtonTapped: Driver<Bool>
        let clapButtonTapped: Driver<Int>
    }
    
    // MARK: - Outputs
    
    public class Output {
        @Published var listDetailModel: ListDetailModel?
        var editSuccessed = PassthroughSubject<Bool, Never>()
        var showDeleteAlert = PassthroughSubject<Bool, Never>()
        var deleteSuccessed = PassthroughSubject<Bool, Never>()
        var bottomButtonEnabled = PassthroughSubject<Bool, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
        var clapResult = PassthroughSubject<Result<ClapCountModel, Error>, Never>()
    }
    
    // MARK: - init
    
    public init(
        useCase: ListDetailUseCase,
        sceneType: ListDetailSceneType,
        isAppjam: Bool? = nil,
        starLevel: StarViewLevel,
        missionId: Int,
        missionTitle: String,
        otherUsername: String?
    ) {
        self.useCase = useCase
        self.sceneType = sceneType
        self.starLevel = starLevel
        self.missionId = missionId
        self.isAppjam = isAppjam
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
                ? owner.useCase.fetchListDetail(isAppjam: owner.isAppjam, missionId: owner.missionId, username: owner.otherUserName)
                : owner.useCase.fetchListDetail(isAppjam: owner.isAppjam, missionId: owner.missionId, username: nil)

                if owner.isOtherUser {
                    AmplitudeInstance.shared.track(
                        eventType: .clickFeedMission,
                        eventProperties: [
                            "missionId": owner.missionId ?? "",
                            "missionTitle": owner.missionTitle ?? "",
                            "missionLevel": owner.starLevel ?? "",
                            "feedOwnerNick": owner.otherUserName ?? ""
                        ]
                    )
                }
            }.store(in: cancelBag)
        
        input.imageSelected
            .flatMap { [weak self] imageData -> Driver<(Data, PresignedUrlModel)> in
                guard let self else { return .empty() }
                output.isLoading.send(true)
                self.useCase.getPresignedURL()
                self.currentImage.send(imageData)
                
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
                output.isLoading.send(false)
            }).store(in: self.cancelBag)

        
        input.bottomButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                return ListDetailRequestModel(
                    missionId: owner.missionId ?? 0,
                    content: owner.currentText.value,
                    activityDate: owner.currentDate.value
                )
            }
            .flatMap { [weak self] requestModel -> Driver<ListDetailRequestModel> in
                guard
                    let self,
                    let presignedUrl = self.uploadedUrl?.removePercentEncodingIfNeeded()
                else { return .empty() }
                
                var requestModel = requestModel
                return Just(requestModel.updateImgUrl(to: presignedUrl)).asDriver()
            }
            .withUnretained(self)
            .sink { owner, requestModel in
                if owner.sceneType == ListDetailSceneType.none {
                    owner.useCase.postStamp(isAppjam: owner.isAppjam, stampData: requestModel)
                } else {
                    owner.useCase.putStamp(stampData: requestModel)
                }
            }
            .store(in: self.cancelBag)
        
        input.rightButtonTapped
            .withUnretained(self)
            .sink { owner, sceneType in
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
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.deleteStamp(stampId: owner.stampId)
            }.store(in: self.cancelBag)
        
        input.textEdited
            .withUnretained(self)
            .sink { owner, text in
                owner.currentText.send(text)
            }.store(in: cancelBag)
        
        input.dateSelected
            .withUnretained(self)
            .sink { owner, date in
                owner.currentDate.send(date)
            }.store(in: cancelBag)
        
        input.clapButtonTapped
            .withUnretained(self)
            .sink {
                owner, count in
                owner.useCase.clap(stampId: owner.stampId, clapCount: count)
                AmplitudeInstance.shared.track(
                    eventType: .clickUpdateClap,
                    eventProperties: [
                        "stampId": owner.stampId ?? 0,
                        "appliedCount": count,
                        "totalClapCount": owner.totalClapCount,
                        "receiverNick": owner.otherUserName ?? ""
                    ]
                )
            }.store(in: cancelBag)

        // 버튼 활성화 로직
        Publishers.CombineLatest3(currentImage, currentDate, currentText)
            .withUnretained(self)
            .filter { owner, _ in
                owner.sceneType != .completed
            }
            .map { owner, currentState in
                let (currentImage, currentDate, currentText) = currentState
                
                switch owner.sceneType {
                case .edit:
                    let isImageSelected = owner.isImageSelected(currentImage)
                    let isDateChanged = owner.isDateChanged(output.listDetailModel?.activityDate, currentDate)
                    let isTextChanged = owner.isTextChanged(output.listDetailModel?.content, currentText)
                    return isImageSelected || isDateChanged || isTextChanged
                default:
                    let isImageSelected = !currentImage.isEmpty
                    let isDateChanged = !currentDate.isEmpty
                    let isTextChanged = !currentText.isEmpty
                    return isImageSelected && isDateChanged && isTextChanged
                }
            }
            .sink { isEdited in
                output.bottomButtonEnabled.send(isEdited)
            }
            .store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let listDetailModel = useCase.listDetailModel
        let editSuccess = useCase.editSuccess
        let deleteSuccess = useCase.deleteSuccess
        let clapResult = useCase.clapResult
        
        listDetailModel.asDriver()
            .withUnretained(self)
            .compactMap { owner, model in
                owner.stampId = model.stampId
                owner.uploadedUrl = model.image
                owner.totalClapCount = model.clapCount
                owner.myClapCount = model.myClapCount ?? 0
                owner.viewcount = model.viewCount
                if let mine = model.isMine {
                    owner.isOtherUser = !mine
                }
                return model
            }
            .assign(to: \.self.listDetailModel, on: output)
            .store(in: self.cancelBag)

        editSuccess.asDriver()
            .withUnretained(self)
            .sink { owner, success in
                output.editSuccessed.send(success)
            }.store(in: self.cancelBag)
        
        deleteSuccess.asDriver()
            .withUnretained(self)
            .sink { owner, success in
                output.deleteSuccessed.send(success)
            }.store(in: self.cancelBag)
        
        clapResult.asDriver()
            .withUnretained(self)
            .sink { owner, result in
                output.clapResult.send(result)
            }.store(in: self.cancelBag)
    }
}

// MARK: - Methods

extension ListDetailViewModel {
    private func isImageSelected(_ image: Data) -> Bool {
        return !image.isEmpty
    }
    
    private func isDateChanged(_ originDate: String?, _ currentDate: String) -> Bool {
        guard let originDate else { return false }
        return !currentDate.isEmpty && originDate != currentDate
    }
    
    private func isTextChanged(_ originText: String?, _ currentText: String) -> Bool {
        guard let originText else { return false }
        return !originText.isEmpty && originText != currentText
    }
}
