//
//  PokeMainViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface

public class PokeMainViewModel:
    PokeMainViewModelType {
    
    typealias UserId = String
    
    public var onNaviBackTap: (() -> Void)?
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let naviBackButtonTap: Driver<Void>
        let pokedSectionHeaderButtonTap: Driver<Void>
        let friendSectionHeaderButtonTap: Driver<Void>
        let pokedSectionKokButtonTap: Driver<UserId?>
        let friendSectionKokButtonTap: Driver<UserId?>
        let nearbyFriendsSectionKokButtonTap: Driver<UserId?>
        let refreshRequest: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - initialization
    
    public init() {
        
    }
}
    
extension PokeMainViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.naviBackButtonTap
            .sink { [weak self] _ in
                self?.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.pokedSectionHeaderButtonTap
            .sink { _ in
                print("찌르기 알림 뷰로 이동")
            }.store(in: cancelBag)
        
        input.friendSectionHeaderButtonTap
            .sink { _ in
                print("내 친구 뷰로 이동")
            }.store(in: cancelBag)
        
        input.pokedSectionKokButtonTap
            .compactMap { $0 }
            .sink { userId in
                print("찌르기 - \(userId)")
            }.store(in: cancelBag)

        input.friendSectionKokButtonTap
            .compactMap { $0 }
            .sink { userId in
                print("찌르기 - \(userId)")
            }.store(in: cancelBag)
        
        input.nearbyFriendsSectionKokButtonTap
            .compactMap { $0 }
            .sink { userId in
                print("찌르기 - \(userId)")
            }.store(in: cancelBag)
        
        input.refreshRequest
            .sink { _ in
                print("리프레시 요청")
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    }
}
