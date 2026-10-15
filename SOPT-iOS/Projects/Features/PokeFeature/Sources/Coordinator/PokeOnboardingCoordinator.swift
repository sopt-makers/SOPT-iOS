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

public final class PokeOnboardingCoordinator: BaseCoordinator {
    
    // MARK: - Properties
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
            // 고정 높이 대신 콘텐츠 제약(패딩)으로 높이 계산
            let height = viewController.view.systemLayoutSizeFitting(
                CGSize(width: UIScreen.main.bounds.width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
            let bottomSheetManager = BottomSheetManager(configuration: .fixed(minHeight: height, prefersGrabberVisible: true))
            bottomSheetManager.present(toPresent: viewController, on: self?.rootController)
        }
        
        pokeOnboarding.vm.onPokeButtonTapped = { [weak self] userModel in
            let messageTemplateConfig = PokeMessageTemplateConfig(isAnonymousSelectionAvailable: userModel.pokeNum < 10)
            
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: .pokeSomeone, config: messageTemplateConfig)
                    .vc as? PokeMessageTemplateBottomSheet
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
