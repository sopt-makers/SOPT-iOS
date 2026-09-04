//
//  SoptlogViewModel.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import PokeFeatureInterface

import BaseFeatureDependency

public class SoptlogViewModel: SoptlogViewModelType {
    
    // MARK: - Properties
    
    private let useCase: SoptlogUseCase
    private let coordinator: AnyCoordinatorObject
    private var fetchSoptlogInfoTask: Task<Void, Never>?
    private var cancelBag = CancelBag()

    private let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    public var isActiveUser: Bool { userType == .active }
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let viewWillAppear: Driver<Void>
        let cellTap: Driver<SoptlogCellTapInfo>
        let toolTipButtonTap: Driver<CGRect>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let soptlogInfo = PassthroughSubject<SoptlogPresentationModel, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - SoptlogCoordinatable
    
    public var onToolTipTapped: ((CGRect) -> Void)?
    public var onSoptuneTapped: (() -> Void)?
    public var onNetworkError: (@MainActor () -> Void)?
    public var onAuthFailed: (@MainActor () -> Void)?
    public var onSoptampHomeTapped: (() -> Void)?
    public var onPokeHomeTapped: (() -> Void)?
    public var onPokeMyFriendsTapped: ((PokeRelation) -> Void)?
    
    
    // MARK: - initialization
    
    public init(useCase: SoptlogUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    deinit {
        self.fetchSoptlogInfoTask?.cancel()
        self.fetchSoptlogInfoTask = nil
    }
}

extension SoptlogViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                AmplitudeInstance.shared.trackWithUserType(event: .viewSoptlogMain)
                owner.fetchSoptlogInfoTask?.cancel()
                owner.fetchSoptlogInfoTask = Task {
                    await self.handleViewWillAppear(output: output)
                }
            }.store(in: cancelBag)
        
        input.cellTap
            .filter { $0.section == .soptampLog }
            .withUnretained(self)
            .sink { owner, tapInfo in
                if tapInfo.row == 0 {
                    owner.onSoptampHomeTapped?()
                }
            }.store(in: cancelBag)
                
        input.cellTap
            .filter { $0.section == .pokeLog }
            .withUnretained(self)
            .sink { owner, tapInfo in
                switch tapInfo.row {
                case 0:
                    owner.onPokeHomeTapped?()
                case 1:
                    owner.onPokeMyFriendsTapped?(.newFriend)
                case 2:
                    owner.onPokeMyFriendsTapped?(.bestFriend)
                case 3:
                    owner.onPokeMyFriendsTapped?(.soulmate)
                default:
                    break
                }
            }.store(in: cancelBag)
        
//        input.cellTap
//            .filter{ $0.section == .banner }
//            .withUnretained(self)
//            .sink { owner, _ in
//                owner.onSoptuneTapped?()
//            }.store(in: cancelBag)
        
        input.toolTipButtonTap
            .withUnretained(self)
            .sink { owner, toolTipFrame in
                owner.onToolTipTapped?(toolTipFrame)
            }.store(in: cancelBag)
        
        return output
    }
}

extension SoptlogViewModel {
    private func handleViewWillAppear(output: Output) async {
        output.isLoading.send(true)
        
        do {
            let model = try await useCase.fetchSoptlogInfo()
            let info = model.toPresentation()
            output.soptlogInfo.send(info)
        } catch let error as MainError {
            switch error {
            case .networkError(_):
                print("🚨 네트워크 에러")
                await onNetworkError?()
            case .authFailed:
                print("🚨 SoptlogViewModel: 인증에 실패했습니다.")
                await onAuthFailed?()
            }
        } catch {
            print("🚨 SoptlogViewModel: Unknown error: \(error)")
        }
        
        output.isLoading.send(false)
    }
}
