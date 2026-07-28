//
//  MyPageFeatureControllables.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Core

public protocol WithdrawalViewCoordinatable {
    var onWithdrawal: (@MainActor (String) -> Void)? { get set }
    var onWithdrawalConfirm: ((_ completion: @escaping ()->())->Void)? { get set }
}

public typealias WithdrawalViewModelType = ViewModelType & WithdrawalViewCoordinatable
public typealias WithdrawalPresentable = (vc: UIViewController, vm: any WithdrawalViewModelType)
