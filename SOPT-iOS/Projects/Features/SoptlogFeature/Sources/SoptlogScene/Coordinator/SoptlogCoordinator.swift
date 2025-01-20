//
//  SoptlogCoordinator.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain

import BaseFeatureDependency
import SoptlogFeatureInterface
import WebFeature

public final class SoptlogCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: SoptlogFeatureBuildable
    private let router: Router
    
    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: SoptlogFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        showSoptlog()
    }
    
    private func showSoptlog() {
        var soptlog = factory.makeSoptlog()
        
        soptlog.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        
        soptlog.vm.onProfileEditTapped = { [weak self] in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/edit") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        self.rootController = soptlog.vc.asNavigationController
        self.router.present(self.rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
}
