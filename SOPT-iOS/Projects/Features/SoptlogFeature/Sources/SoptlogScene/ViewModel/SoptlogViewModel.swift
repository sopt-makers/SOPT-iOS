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

import BaseFeatureDependency

public class SoptlogViewModel: SoptlogViewModelType {
    
    // MARK: - Properties

    private let useCase: SoptlogUseCase
    private var cancelBag = CancelBag()

    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let cellTap: Driver<IndexPath>
        let toolTipButtonTap: Driver<CGRect>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let soptlogInfo = PassthroughSubject<SoptlogPresentationModel, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - SoptlogCoordinatable
    
    public var onProfileEditTapped: (() -> Void)?
    public var onToolTipTapped: ((CGRect) -> Void)?
    public var onSoptuneTapped: (() -> Void)?
    public var onNetworkError: (() -> Void)?
    
    
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
                            print("인증에 실패했습니다.")
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
        
        input.toolTipButtonTap
            .withUnretained(self)
            .sink { owner, toolTipFrame in
                owner.onToolTipTapped?(toolTipFrame)
            }.store(in: cancelBag)

        return output
    }
}
