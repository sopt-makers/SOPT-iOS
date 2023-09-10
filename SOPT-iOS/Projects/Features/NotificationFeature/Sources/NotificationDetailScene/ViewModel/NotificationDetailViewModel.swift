//
//  NotificationDetailViewModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

public class NotificationDetailViewModel: ViewModelType {

    // MARK: - Properties
    
    private let useCase: NotificationDetailUseCase
    private var cancelBag = CancelBag()
    
    private var notification: NotificationListModel
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var notification = PassthroughSubject<NotificationListModel, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: NotificationDetailUseCase, notification: NotificationListModel) {
        self.useCase = useCase
        self.notification = notification
    }
}

// MARK: - Methods

extension NotificationDetailViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .sink { [weak self] _ in
                guard let self = self else { return }
                output.notification.send(notification)
            }.store(in: cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
