//
//  Router.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import SafariServices

/// RouterProtocol은 Coordinator에서 화면전환의 종류를 지정합니다.
public protocol RouterProtocol: ViewControllable {
    
    var topViewController: UIViewController? { get }
    
    func present(_ module: ViewControllable?)
    func present(_ module: ViewControllable?, animated: Bool)
    func present(_ module: ViewControllable?, animated: Bool, modalPresentationSytle: UIModalPresentationStyle)
    func present(_ module: ViewControllable?, animated: Bool, completion: (() -> Void)?)
    func pushSOPTWebView(url: String)
    func presentSafari(url: String)
    
    func push(_ module: ViewControllable?)
    func push(_ module: ViewControllable?, transition: UIViewControllerAnimatedTransitioning?)
    func push(_ module: ViewControllable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func push(_ module: ViewControllable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?)
    
    func popModule()
    func popModule(transition: UIViewControllerAnimatedTransitioning?)
    func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    
    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: ViewControllable?, animated: Bool)
    func setRootModule(_ module: ViewControllable?, hideBar: Bool, animated: Bool)
    
    func replaceRootWindow(_ module: ViewControllable, withAnimation: Bool, completion: ((UIWindow) -> Void)?)
    
    func popToRootModule(animated: Bool)
    func popToModule(module: ViewControllable?, animated: Bool)
    
    func showTitles()
    func hideTitles()
    
    func presentAlertVC(
        type: AlertType,
        theme: AlertVC.AlertTheme,
        title: String,
        description: String,
        customButtonTitle: String,
        customAction: (() -> Void)?,
        animated: Bool,
        completion: (() -> Void)?
    )
    
    func presentNetworkAlertVC(
        theme: AlertVC.AlertTheme,
        animated: Bool,
        completion: (() -> Void)?
    )
}

/// RouterProtocol을 채택하여 Coordinator가 모르는 화면전환의 기능을 수행합니다. RootController를 가지고 다양한 기능을 수행합니다.
public
final class Router: NSObject, RouterProtocol {
    
    
    
    // MARK: - Vars & Lets
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    private var transition: UIViewControllerAnimatedTransitioning?
    
    public var topViewController: UIViewController? {
        self.rootController?.topViewController
    }
    
    // MARK: - ViewControllable
    
    public var viewController: UIViewController {
        return self.rootController ?? UIViewController()
    }
    public var asNavigationController: UINavigationController {
        return rootController ?? UINavigationController(rootViewController: viewController)
    }
    
    // MARK: - RouterProtocol
    
    public func present(_ module: ViewControllable?) {
        self.present(module, animated: true)
    }
    
    public func present(_ module: ViewControllable?, animated: Bool) {
        guard let controller = module?.viewController else { return }
        self.rootController?.present(controller, animated: animated, completion: nil)
    }
    
    public func present(_ module: ViewControllable?, animated: Bool, modalPresentationSytle: UIModalPresentationStyle) {
        guard let controller = module?.viewController else { return }
        controller.modalPresentationStyle = modalPresentationSytle
        self.rootController?.present(controller, animated: animated, completion: nil)
    }
    
    public func present(_ module: ViewControllable?, animated: Bool, modalPresentationSytle: UIModalPresentationStyle, modalTransitionStyle: UIModalTransitionStyle) {
        guard let controller = module?.viewController else { return }
        controller.modalPresentationStyle = modalPresentationSytle
        controller.modalTransitionStyle = modalTransitionStyle
        self.rootController?.present(controller, animated: animated, completion: nil)
    }
    
    public func present(_ module: ViewControllable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.viewController else { return }
        self.rootController?.present(controller, animated: animated, completion: completion)
    }
    
    public func pushSOPTWebView(url: String) {
        guard let url = URL(string: url) else { return }
        
        let webView = SOPTWebView(startWith: url)
        self.rootController?.pushViewController(webView, animated: true)
    }
    
    public func presentSafari(url: String) {
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        safariViewController.playgroundStyle()
        self.rootController?.present(safariViewController, animated: true)
    }
    
    public func push(_ module: ViewControllable?)  {
        self.push(module, transition: nil)
    }
    
    public func push(_ module: ViewControllable?, transition: UIViewControllerAnimatedTransitioning?) {
        self.push(module, transition: transition, animated: true)
    }
    
    public func push(_ module: ViewControllable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool)  {
        self.push(module, transition: transition, animated: animated, completion: nil)
    }
    
    public func push(_ module: ViewControllable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?) {
        self.transition = transition
        
        guard let controller = module?.viewController,
              (controller is UINavigationController == false)
        else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            self.completions[controller] = completion
        }
        self.rootController?.pushViewController(controller, animated: animated)
        
        self.transition = nil
    }
    
    public func popModule()  {
        self.popModule(transition: nil)
    }
    
    public func popModule(transition: UIViewControllerAnimatedTransitioning?) {
        self.popModule(transition: transition, animated: true)
    }
    
    public func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        self.transition = transition
        
        if let controller = rootController?.popViewController(animated: animated) {
            self.runCompletion(for: controller)
        }
        
        self.transition = nil
    }
    
    public func popToModule(module: ViewControllable?, animated: Bool = true) {
        if let controllers = self.rootController?.viewControllers , let module = module {
            for controller in controllers {
                if controller == module as! UIViewController {
                    self.rootController?.popToViewController(controller, animated: animated)
                    self.runCompletion(for: controller)
                    break
                }
            }
        }
    }
    
    public func dismissModule(animated: Bool) {
        self.dismissModule(animated: animated, completion: nil)
    }
    
    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        self.rootController?.dismiss(animated: animated, completion: completion)
    }
    
    public func setRootModule(_ module: ViewControllable?, animated: Bool) {
        self.setRootModule(module, hideBar: false, animated: animated)
    }
    
    public func setRootModule(_ module: ViewControllable?, hideBar: Bool, animated: Bool) {
        guard let controller = module?.viewController else { return }
        self.rootController?.setViewControllers([controller], animated: animated)
        self.rootController?.isNavigationBarHidden = hideBar
    }
    
    public func replaceRootWindow(_ module: ViewControllable, withAnimation: Bool, completion: ((UIWindow) -> Void)? = nil) {
        let viewController = module.viewController
        let window = UIWindow.keyWindowGetter!
        let navigation = UINavigationController(rootViewController: viewController)
        
        self.rootController = navigation
        
        if !withAnimation {
            window.rootViewController = navigation
            window.makeKeyAndVisible()
            return
        }
        
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = navigation
            window.makeKeyAndVisible()
            
            completion?(window)
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
    
    public func setRootWindow(_ module: ViewControllable) {
        let viewController = module.viewController
        let window = UIWindow.keyWindowGetter!
        let navigation = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    public func popToRootModule(animated: Bool) {
        if let controllers = self.rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                self.runCompletion(for: controller)
            }
        }
    }
    
    public func showTitles() {
        self.rootController?.isNavigationBarHidden = false
        self.rootController?.navigationBar.prefersLargeTitles = true
        self.rootController?.navigationBar.tintColor = UIColor.black
    }
    
    public func hideTitles() {
        self.rootController?.isNavigationBarHidden = true
    }
    
    public func showBottomSheet(manager: BottomSheetManager, toPresent: UIViewController, on view: UIViewController?) {
        manager.present(toPresent: toPresent, on: view)
    }

    // MARK: - Private methods
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = self.completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    // MARK: - Init methods
    
    public init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completions = [:]
        super.init()
    }
}

// MARK: - Alert

extension Router {
    public func presentAlertVC(
        type: AlertType,
        theme: AlertVC.AlertTheme = .main,
        title: String,
        description: String = "",
        customButtonTitle: String,
        customAction: (() -> Void)? = nil,
        animated: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = AlertVC(alertType: type, alertTheme: theme)
            .setTitle(title, description)
            .setCustomButtonTitle(customButtonTitle)
        alertVC.customAction = customAction
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: animated, completion: completion)
    }
    
    public func presentNetworkAlertVC(
        theme: AlertVC.AlertTheme = .main,
        animated: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = AlertVC(alertType: .networkErr, alertTheme: theme)
            .setTitle(I18N.Default.networkError, I18N.Default.networkErrorDescription)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: animated, completion: completion)
    }
}

extension Router: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
}
