//
//  SoptletterMainPresentable.swift
//  SoptletterFeature
//
//  Created by dev on 6/30/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol SoptletterMainRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onPostItTap: (() -> Void)? { get set }
    var onWriteTap: (() -> Void)? { get set }
    var onDownloadTap: ((String, UIImage, URL) -> Void)? { get set }
    var onReportTap: (() -> Void)? { get set }
    var onMenuTap: (() -> Void)? { get set }
    var onCellTap: ((Int, Int) -> Void)? { get set }
    var onError: (() -> Void)? { get set }    
    
    func refreshMessagesTrigger()
    func changeTopic(_ topicId: Int)
}

public typealias SoptletterMainViewModelType = ViewModelType & SoptletterMainRoutingTrigger
public typealias SoptletterMainPresentable = (vc: UIViewController, vm: any SoptletterMainViewModelType)

