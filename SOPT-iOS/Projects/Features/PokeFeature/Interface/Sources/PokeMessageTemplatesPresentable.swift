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

public protocol PokeMessageTemplatesViewControllable: UIViewController {
    var minimumContentHeight: CGFloat { get }
    
    func signalForClick() -> Driver<(PokeMessageModel, isAnonymous: Bool)>
}

public protocol PokeMessageTemplatesRoutingTrigger { }

public protocol PokeMessageTemplatesViewModelType: ViewModelType & PokeMessageTemplatesRoutingTrigger {
    var messageType: PokeMessageType { get }
}

public typealias PokeMessageTemplatesPresentable = (vc: PokeMessageTemplatesViewControllable, vm: any PokeMessageTemplatesRoutingTrigger)
