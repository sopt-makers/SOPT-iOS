//
//  PokeMessageTemplatesPresentable.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core
import Domain

public protocol PokeMessageTemplatesViewControllable: ViewControllable {
    var minimumContentHeight: CGFloat { get }
    
    func signalForClick() -> Driver<(PokeMessageModel, isAnonymous: Bool)>
}

public protocol PokeMessageTemplatesCoordinatable { }

public protocol PokeMessageTemplatesViewModelType: ViewModelType & PokeMessageTemplatesCoordinatable {
    var messageType: PokeMessageType { get }
}
public typealias PokeMessageTemplatesPresentable = (vc: PokeMessageTemplatesViewControllable, vm: any PokeMessageTemplatesCoordinatable)

