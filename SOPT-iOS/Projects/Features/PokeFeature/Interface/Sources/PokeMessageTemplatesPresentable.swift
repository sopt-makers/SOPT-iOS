//
//  PokeMessageTemplatesPresentable.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol LegacyPokeMessageTemplatesViewControllable: LegacyViewControllable {
    var minimumContentHeight: CGFloat { get }
    
    func signalForClick() -> Driver<(PokeMessageModel, isAnonymous: Bool)>
}
public protocol PokeMessageTemplatesViewControllable: UIViewController {
    var minimumContentHeight: CGFloat { get }
    
    func signalForClick() -> Driver<(PokeMessageModel, isAnonymous: Bool)>
}

public protocol PokeMessageTemplatesCoordinatable { }

public protocol PokeMessageTemplatesViewModelType: ViewModelType & PokeMessageTemplatesCoordinatable {
    var messageType: PokeMessageType { get }
}
public typealias LegacyPokeMessageTemplatesPresentable = (vc: LegacyPokeMessageTemplatesViewControllable, vm: any PokeMessageTemplatesCoordinatable)
public typealias PokeMessageTemplatesPresentable = (vc: PokeMessageTemplatesViewControllable, vm: any PokeMessageTemplatesCoordinatable)
