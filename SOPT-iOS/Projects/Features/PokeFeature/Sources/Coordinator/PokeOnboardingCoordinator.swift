//
//  PokeOnboardingCoordinator.swift
//  PokeFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface
import WebFeature

public final class PokeOnboardingCoordinator: DefaultCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: PokeFeatureBuildable
    private let navigationController: UINavigationController
    private weak var rootController: UINavigationController?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: PokeFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showPokeOnboardingView()
    }
    
    // MARK: - Navigation
    
    private func showPokeOnboardingView() {
        let pokeOnboarding = makePokeOnboardingView()
        
        let navController = UINavigationController(rootViewController: pokeOnboarding.vc)
        rootController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func makePokeOnboardingView() -> PokeOnboardingPresentable {
        var pokeOnboarding = factory.makePokeOnboarding(coordinator: self)
        
        pokeOnboarding.vm.onNaviBackTapped = { [weak self] in
            self?.navigationController.dismiss(animated: true)            
        }
        
        pokeOnboarding.vm.onFirstVisitInOnboarding = { [weak self] in
            let viewController = PokeOnboardingBottomSheet()
            let bottomSheetManager = BottomSheetManager(configuration: .onboarding(minHeight: PokeOnboardingBottomSheet.minHeight))
            bottomSheetManager.present(toPresent: viewController, on: self?.rootController)
        }
        
        pokeOnboarding.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: .pokeSomeone)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: PokeMessageTemplateBottomSheet.minimumContentHeight))
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
