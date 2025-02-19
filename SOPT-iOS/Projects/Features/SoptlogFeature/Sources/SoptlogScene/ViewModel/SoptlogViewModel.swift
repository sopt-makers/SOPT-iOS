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
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let cellTap: Driver<IndexPath>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let soptlogInfo = PassthroughSubject<SoptlogPresentationModel, Never>()
    }
    
    // MARK: - SoptlogCoordinatable
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onProfileEditTapped: (() -> Void)?
    public var onAlarmTapped: (() -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: SoptlogUseCase, cancelBag: CancelBag = CancelBag()) {
        self.useCase = useCase
        self.cancelBag = cancelBag
    }
}

extension SoptlogViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .flatMap(useCase.fetchSoptlogInfo)
            .withUnretained(self)
            .sink { owner, soptlogModel in
                let info = soptlogModel.toPresentation()
                output.soptlogInfo.send(info)
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: cancelBag)
        
        input.cellTap
            .filter{ $0.section == 2 }
            .withUnretained(self)
            .sink { owner, _ in
                owner.onProfileEditTapped?()
            }.store(in: cancelBag)
        
        input.cellTap
            .filter{ $0.section == 3 }
            .withUnretained(self)
            .sink { owner, _ in
                owner.onAlarmTapped?()
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
