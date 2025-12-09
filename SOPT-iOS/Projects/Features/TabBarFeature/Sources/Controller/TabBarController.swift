//
//  TabBarController.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let tabList: [UIViewController]
    private let viewModel: TabBarViewModel
    
    private let isTabBarItemSelected = PassthroughSubject<Int, Never>()
    private let userType: UserType
    private let cancelBag = CancelBag()
    
    // MARK: - Life Cycle
    
    init(viewModel: TabBarViewModel, tabList: [UIViewController], userType: UserType) {
        self.viewModel = viewModel
        self.tabList = tabList
        self.userType = userType

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModels()
        
        configureTabBar()
        configureTabBarItem()
        
        setDelegate()
    }
    
    override public func viewDidLayoutSubviews() {
        configureTabBarHeight()
    }
    
    deinit {
        self.delegate = nil
    }
}

// MARK: - UI & Layout

extension TabBarController {
    private func configureTabBar() {
        UITabBar.clearShadow()
        view.tintColor = .white
        tabBar.backgroundColor = DSKitAsset.Colors.gray800.color
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureTabBarHeight() {
        var tabFrame = tabBar.frame
        tabFrame.size.height = 82
        tabFrame.origin.y = view.frame.size.height - tabFrame.size.height
        
        tabBar.frame = tabFrame
    }
    
    private func configureTabBarItem() {
        let tabs: [TabBarItemType]

        switch self.userType{
        case .active:
            tabs = [.home, .soptstamp, .poke, .soptlog]
        case .inactive, .visitor:
            tabs = [.home, .poke, .soptlog]
        }

        tabs.enumerated().forEach { index, tabType in
            let viewController = tabList[index]
            viewController.tabBarItem = tabType.makeTabBarItem()
            viewController.tabBarItem.tag = index
            viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
            viewController.tabBarItem.setTitleTextAttributes(
                [NSAttributedString.Key.font: DSKitFontFamily.Suit.medium.font(size: 10)],
                for: .normal
            )
        }

        setViewControllers(tabList, animated: true)
    }
}

// MARK: - Methods

extension TabBarController {
    private func bindViewModels() {
        let input = TabBarViewModel.Input(
            isTabSelectedIndex: isTabBarItemSelected.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.selectedIndex
            .withUnretained(self)
            .sink { owner, index in
                owner.selectedIndex = index
            }.store(in: cancelBag)
    }
    
    private func setDelegate() {
        self.delegate = self
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        isTabBarItemSelected.send(index)
    }
}
