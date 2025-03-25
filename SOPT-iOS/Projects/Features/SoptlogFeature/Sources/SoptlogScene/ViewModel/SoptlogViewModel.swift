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

import HomeFeatureInterface
import BaseFeatureDependency

public class SoptlogViewModel: SoptlogViewModelType {
    
    // MARK: - Properties

    private let useCase: SoptlogUseCase
    private var cancelBag = CancelBag()

    // MARK: - Inputs
    
    public struct Input { 
        let viewWillAppear: Driver<Void>
        let cellTap: Driver<IndexPath>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let soptlogInfo = PassthroughSubject<SoptlogPresentationModel, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - SoptlogCoordinatable
    
    public var onProfileEditTapped: (() -> Void)?
    public var onSoptuneTapped: (() -> Void)?
    public var onNetworkError: (() -> Void)?
    public var onNeedSignIn: (() -> Void)?
    
    
    // MARK: - initialization
    
    public init(useCase: SoptlogUseCase, cancelBag: CancelBag = CancelBag()) {
        self.useCase = useCase
        self.cancelBag = cancelBag
    }
}

extension SoptlogViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .handleEvents(receiveOutput: { _ in
                output.isLoading.send(true)
            })
            .flatMap{ _ in
                self.useCase.fetchSoptlogInfo()
                    .catch { error  -> AnyPublisher<SoptlogModel, Never> in
                        switch error {
                        case .networkError(_):
                            self.onNetworkError?()
                            return Empty().eraseToAnyPublisher()
                        case .authFailed:
                            self.onNeedSignIn?()
                            return Empty().eraseToAnyPublisher()
                        }
                    }
            }
            .compactMap{ $0 }
            .withUnretained(self)
            .sink { owner, soptlogModel in
                let info = soptlogModel.toPresentation()
                output.soptlogInfo.send(info)
                output.isLoading.send(false)
            }.store(in: cancelBag)
        
        input.cellTap
            .filter{ $0.section == 2 }
            .withUnretained(self)
            .sink { owner, _ in
                owner.onProfileEditTapped?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickSoptlogEditProfile)
            }.store(in: cancelBag)
        
        input.cellTap
            .filter{ $0.section == 3 }
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSoptuneTapped?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickSoptlogSoptune)
            }.store(in: cancelBag)

        return output
    }
}

extension SoptlogModel {
    func toPresentation() -> SoptlogPresentationModel {
        var appService: [SoptlogPresentationModel.AppService] = []
        appService.append(SoptlogPresentationModel.AppService(
            serviceName: I18N.Soptlog.soptlevel,
            serviceImageURL: self.icons[0],
            serviceValue: self.soptLevel))
        appService.append(SoptlogPresentationModel.AppService(
            serviceName: I18N.Soptlog.poke,
            serviceImageURL: self.icons[1],
            serviceValue: self.pokeCount))
        
        if self.isActive {
            appService.append(SoptlogPresentationModel.AppService(
                serviceName: I18N.Soptlog.soptamp,
                serviceImageURL: self.icons[2],
                serviceValue: self.soptampRank))
        } else {
            appService.append(SoptlogPresentationModel.AppService(
                serviceName: I18N.Soptlog.withSopt,
                serviceImageURL: self.icons[2],
                serviceValue: self.during))
        }
        
        
        return SoptlogPresentationModel(
            profile: SoptlogPresentationModel.Profile(
                userName: self.userName,
                profileImage: self.profileImage,
                part: self.part
            ),
            introduce: SoptlogPresentationModel.Introduce(
                profileMessage: self.profileMessage
            ),
            appService: appService,
            alarm: SoptlogPresentationModel.Alarm(
                isFortuneChecked: self.isFortuneChecked,
                todayFortuneText: self.todayFortuneText
            )
        )
    }
}
