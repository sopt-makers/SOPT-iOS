//
//  WithDrawalViewModel.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/12.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain
import BaseFeatureDependency

public class WithdrawalViewModel: WithdrawalViewModelType {
    
    // MARK: - Trigger
    
    public var onWithdrawal: (@MainActor (String) -> Void)?
    public var onWithdrawalConfirm: ((_ completion: @escaping ()->()) -> Void)?
    
    // MARK: - Properties
    
    private let useCase: SettingUseCase
    private var cancelBag = CancelBag()
    
    private var submitTask: Task<Void, Never>?
    
    // MARK: - Inputs
    
    public struct Input {
        let withdrawalButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var withdrawalSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: SettingUseCase) {
        self.useCase = useCase
    }

    deinit {
        submitTask?.cancel()
    }
}

extension WithdrawalViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.withdrawalButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onWithdrawalConfirm?(owner.withdrawRequest)
            }.store(in: cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.withdrawalSuccess.asDriver()
            .sink { success in
                output.withdrawalSuccessed.send(success)
            }.store(in: self.cancelBag)
    }
    
    private func withdrawRequest() {
        submitTask?.cancel()
        submitTask = Task { [weak self] in
            guard let self else { return }
            do {
                let formUrl = try await self.useCase.withdrawalRequest()
                guard !Task.isCancelled else { return }
                await self.onWithdrawal?(formUrl)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    ToastUtils.showMDSToast(type: .alert, text: I18N.Soptletter.submitFailure)
                }
            }
        }
    }
}
