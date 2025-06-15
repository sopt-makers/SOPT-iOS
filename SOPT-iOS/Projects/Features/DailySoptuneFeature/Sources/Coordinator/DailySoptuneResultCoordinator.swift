//
//  DailySoptuneResultCoordinator.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 6/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import DailySoptuneFeatureInterface
import Domain
import PokeFeatureInterface
import WebFeature


public final class DailySoptuneResultCoordinator: DefaultDailySoptuneCoordinator & DailySoptuneResultCoordinatable {
    
    // MARK: - Coordintable
    
    public var onNaviBackButtonTapped: (() -> Void)?
    public var onKokButtonTapped: ((Domain.PokeUserModel) -> Core.Driver<(Domain.PokeUserModel, Domain.PokeMessageModel, isAnonymous: Bool)>)?
    public var onReceiveTodaysFortuneCardButtonTapped: ((Domain.DailySoptuneCardModel) -> Void)?
    public var onProfileImageTapped: ((Int) -> Void)?
    
    // MARK: - Properties
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneBuildable
    private let pokeFactory: PokeFeatureBuildable
    private let resultModel: DailySoptuneResultModel
    
    private weak var navigationController: UINavigationController?
    private weak var rootController: UINavigationController?

    public init(
        navigationController: UINavigationController,
        factory: DailySoptuneBuildable,
        pokeFactory: PokeFeatureBuildable,
        resultModel: DailySoptuneResultModel
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.pokeFactory = pokeFactory
        self.resultModel = resultModel
    }
    
    public override func start() {
        showDailySoptuneResult(resultModel: resultModel)
    }
    
    private func showDailySoptuneResult(resultModel: DailySoptuneResultModel) {
        let dailySoptuneResult = factory.makeDailySoptuneResultVC(resultModel: resultModel, coordinator: self)
        
        onNaviBackButtonTapped = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
        
        onKokButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: rootController)
        }
        
        onReceiveTodaysFortuneCardButtonTapped = { [weak self] cardModel in
            guard let self else { return }
            self.showDailySoptuneCard(cardModel)
        }
        
        onProfileImageTapped = { [weak self] playgroundId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        let navController = UINavigationController(rootViewController: dailySoptuneResult.vc)
        navController.modalPresentationStyle = .overFullScreen
        rootController = navController
        navigationController?.present(navController, animated: true)
    }
    
    private func showDailySoptuneCard(_ cardModel: DailySoptuneCardModel) {
        var dailySoptuneCard = factory.makeDailySoptuneCardVC(cardModel: cardModel)
        
        dailySoptuneCard.vm.onBackButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.rootController?.dismiss(animated: true)
        }
        
        dailySoptuneCard.vm.onGoToHomeButtonTapped = { [weak self] in
            CoordinatorUtils.dismissToRootNavigation()
            self?.requestCoordinating?()
            self?.finishFlow?()
        }
        
        dailySoptuneCard.vc.modalPresentationStyle = .overFullScreen
        rootController?.present(dailySoptuneCard.vc, animated: true)
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        let messageType: PokeMessageType = userModel.isFirstMeet ? .pokeSomeone : .pokeFriend
        
        guard let bottomSheet = self.pokeFactory
            .makePokeMessageTemplateBottomSheet(messageType: messageType)
            .vc
            .viewController as? PokeMessageTemplatesViewControllable
        else { return .empty() }
        
        let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: bottomSheet.minimumContentHeight))
        
        bottomSheetManager.present(toPresent: bottomSheet.viewController, on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1)}
            .asDriver()
    }
}
