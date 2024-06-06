//
//  PokeOnboardingCoordinator.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeOnboardingCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let router: Router
    private let factory: PokeFeatureBuildable
    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: PokeFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        self.showPokeOnboardingView()
    }
}

extension PokeOnboardingCoordinator {
    private func showPokeOnboardingView() {
        var pokeOnboarding = makePokeOnboardingView()
                
        self.rootController = pokeOnboarding.vc.asNavigationController
        self.router.present(self.rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    func switchToPokeOnboardingView() {
        var pokeOnboarding = makePokeOnboardingView()
        
        self.rootController = router.asNavigationController
        self.router.setRootModule(pokeOnboarding.vc, hideBar: true, animated: false)
    }
    
    func makePokeOnboardingView() -> PokeOnboardingPresentable {
        var pokeOnboarding = self.factory.makePokeOnboarding()
        
        pokeOnboarding.vm.onNaviBackTapped = { [weak self] in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        pokeOnboarding.vm.onFirstVisitInOnboarding = { [weak self] in
            let viewController = PokeOnboardingBottomSheet()
            let bottomSheetManager = BottomSheetManager(configuration: .onboarding())
            self?.router.showBottomSheet(
                manager: bottomSheetManager,
                toPresent: viewController,
                on: self?.rootController
            )
        }
        
        pokeOnboarding.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: .pokeSomeone)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate())
            bottomSheetManager.present(toPresent: bottomSheet, on: self?.rootController)
            
            return bottomSheet
                .signalForClick()
                .map { (userModel, $0, $1) }
                .asDriver()
        }
        
        pokeOnboarding.vm.onAvartarTapped = { [weak self] memberId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(memberId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        return pokeOnboarding
    }
}
