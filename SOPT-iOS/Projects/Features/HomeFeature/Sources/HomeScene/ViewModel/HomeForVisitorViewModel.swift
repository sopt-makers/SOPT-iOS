//
//  HomeForVisitorViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import DSKit

import HomeFeatureInterface
import BaseFeatureDependency

public class HomeForVisitorViewModel: HomeForVisitorViewModelType {
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    let userType: UserType = .visitor
    
    let productServiceList: [HomePresentationModel.ProductService] = [
        .init(product: .officialHomepage),
        .init(product: .project),
        .init(product: .instagram)
    ]
        
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let cellTapped: Driver<HomeForVisitorItem>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let appService = PassthroughSubject<[HomePresentationModel.AppService], Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - HomeForVisitorCoordinating
    
    public var onMainProductCellTapped: ((String) -> Void)?
    public var onAppServiceCellTapped: (() -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension HomeForVisitorViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .handleEvents(receiveOutput: {
                output.isLoading.send(true)
            })
            .flatMap(useCase.getAppServices)
            .withUnretained(self)
            .sink { owner, appServiceModel in
                let appService = appServiceModel.map { $0.toPresentation() }
                output.appService.send(appService)
                output.isLoading.send(false)
            }.store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, item in
                switch item {
                case .appService:
                    owner.onAppServiceCellTapped?()
                case .productService(let model):
                    owner.onMainProductCellTapped?(model.product.serviceDomainLink)
                    owner.trackAmplitude(event: model.product.toAmplitudeEventType)
                default: break
                }
            }
            .store(in: cancelBag)
        
        return output
    }
}

extension HomeForVisitorViewModel {
    private func trackAmplitude(event: AmplitudeEventType?) {
        if let event {
            AmplitudeInstance.shared.trackWithUserType(event: event)
        }
    }
}
