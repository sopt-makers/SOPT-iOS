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
    private let coordinator: AnyCoordinatorObject
    private var fetchSoptlogInfoTask: Task<Void, Never>?
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
                owner.fetchSoptlogInfoTask?.cancel()
                owner.fetchSoptlogInfoTask = Task {
                    await self.handleViewWillAppear(output: output)
                }
            }.store(in: cancelBag)
        
        input.cellTap
            .filter{ $0.section == 1 }
            .withUnretained(self)
            .sink { owner, _ in
                // TODO: - 솝탬프 화면전환
            }.store(in: cancelBag)
        
        input.cellTap
            .filter{ $0.section == 2 }
            .withUnretained(self)
            .sink { owner, _ in
                // TODO: - 콕찌르기 화면전환
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
                onNetworkError?()
            case .authFailed:
                print("🚨 SoptlogViewModel: 인증에 실패했습니다.")
            }
        } catch {
            print("🚨 SoptlogViewModel: Unknown error: \(error)")
        }
        
        output.isLoading.send(false)
    }
}
