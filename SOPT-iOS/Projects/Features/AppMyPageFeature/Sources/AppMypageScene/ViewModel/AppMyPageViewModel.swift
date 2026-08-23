//
//  AppMyPageViewModel.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Foundation
import Combine

import Core
import Domain
import AppMyPageFeatureInterface
import BaseFeatureDependency

public final class AppMyPageViewModel: MyPageViewModelType {
    
    // MARK: - Trigger
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onPolicyItemTap: (() -> Void)?
    public var onTermsOfUseItemTap: (() -> Void)?
    public var onEditOnelineSentenceItemTap: (() -> Void)?
    public var onWithdrawalItemTap: ((Core.UserType) -> Void)?
    public var onShowLogin: (() -> Void)?
    public var onShowLogout: (() -> Void)?
    public var onAlertButtonTap: ((String) -> Void)?
    public var onResetSoptampTap: ((@escaping () -> Void) -> Void)?
    public var onLogoutTap: ((@escaping () -> Void) -> Void)?
    public var onShowSoptlog: (() -> Void)?
    public var onEditProfileTap: (() -> Void)?
    
    // MARK: - Properties
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: AppMyPageUseCase
    private let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTapped: Driver<Void>
        let cellTapped: Driver<MyPageItem>
        let refreshTriggered: Driver<Void>
    }

    // MARK: - Outputs

    public struct Output {
        let resetSuccessed = PassthroughSubject<Bool, Never>()
        let deregisterPushTokenSuccess = PassthroughSubject<Bool, Never>()
        let userProfile = PassthroughSubject<MyPageProfilePresentationModel, Never>()
        let soptlogPreview = PassthroughSubject<MyPageSoptlogPreviewPresentationModel, Never>()
        let fetchError = PassthroughSubject<Void, Never>()
        let fetchCompleted = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - init
    
    public init(useCase: AppMyPageUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension AppMyPageViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        Publishers.Merge(input.viewDidLoad, input.refreshTriggered)
            .withUnretained(self)
            .sink { owner, _ in
                guard owner.userType != .visitor else {
                    output.fetchCompleted.send(())
                    return
                }
                owner.fetchProfileData(output: output)
                AmplitudeInstance.shared.trackWithUserType(event: .viewMypageMain)
            }.store(in: cancelBag)

        input.naviBackButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, item in
                owner.handleCellTap(item: item)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.useCase
            .resetSuccess
            .asDriver()
            .sink { success in
                if success {
                    output.resetSuccessed.send(success)
                } else {
                    AlertUtils.presentNetworkAlertVC()
                }
            }.store(in: cancelBag)
        
        self.useCase
            .deregisterPushTokenSuccess
            .asDriver()
            .withUnretained(self)
            .sink { owner, success in
                if success {
                    owner.useCase.logout()
                    owner.onShowLogin?()
                }
            }.store(in: cancelBag)
    }
    
    private func handleCellTap(item: MyPageItem) {
        switch item.type {
        case .profileCard:
            self.onEditProfileTap?()
            AmplitudeInstance.shared.trackWithUserType(event: .clickProfileEditButton)
        case .soptlogSoptampPreview, .soptlogPokePreview:
            break
        case .soptlogCheckButton:
            self.onShowSoptlog?()
            AmplitudeInstance.shared.trackWithUserType(event: .clickMypageSoptlog)
        case .privacyPolicy:
            self.onPolicyItemTap?()
        case .termsOfUse:
            self.onTermsOfUseItemTap?()
        case .sendFeedback:
            openExternalLink(urlStr: ExternalURL.KakaoTalk.serviceProposal)
            AmplitudeInstance.shared.trackWithUserType(event: .clickMypageFeedback)
        case .setNotification:
            self.onAlertButtonTap?(UIApplication.openSettingsURLString)
            AmplitudeInstance.shared.trackWithUserType(event: .clickMypageNotification)
        case .editOnelineSentence:
            self.onEditOnelineSentenceItemTap?()
            AmplitudeInstance.shared.trackWithUserType(event: .clickMypageEditStatusmessage)
        case .resetStamp:
            self.onResetSoptampTap?({ [weak self] in
                self?.useCase.resetStamp()
            })
            AmplitudeInstance.shared.trackWithUserType(event: .clickMypageResetStamp)
        case .withdrawal:
            self.onWithdrawalItemTap?(userType)
            AmplitudeInstance.shared.trackWithUserType(event: .clickMypageQuit)
        case .logout:
            self.onLogoutTap?({ [weak self] in
                self?.useCase.deregisterPushToken()
                self?.onShowLogout?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickDoneLogout)
            })
        case .login:
            self.onShowLogin?()
        }
    }
}

extension AppMyPageViewModel {
    private func fetchProfileData(output: Output) {
        Task { [weak self] in
            guard let self else { return }
            defer { output.fetchCompleted.send(()) }
            async let profileTask = useCase.fetchUserMainInfo()
            async let soptlogTask = useCase.fetchSoptlogPreview()
            var hasError = false
            if let profile = try? await profileTask { output.userProfile.send(profile.toPresentation()) } else { hasError = true }
            if let soptlog = try? await soptlogTask { output.soptlogPreview.send(soptlog.toPresentation()) } else { hasError = true }
            if hasError { output.fetchError.send(()) }
        }
    }
}
