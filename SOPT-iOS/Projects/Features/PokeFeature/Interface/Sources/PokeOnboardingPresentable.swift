//
//  PokeOnboardingPresentable.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol PokeOnboardingViewControllable: ViewControllable { }

public protocol PokeOnboardingCoordinatable {
    var onNaviBackTapped: (() -> Void)? { get set }
    var onFirstVisitInOnboarding: (() -> Void)? { get set }
    var onAvartarTapped: ((_ playgroundId: String) -> Void)? { get set }
    var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
    var onMyFriendsTapped: (() -> Void)? { get set }
}

public typealias PokeOnboardingViewModelType = ViewModelType & PokeOnboardingCoordinatable
public typealias PokeOnboardingPresentable = (vc: PokeOnboardingViewControllable, vm: any PokeOnboardingViewModelType)

