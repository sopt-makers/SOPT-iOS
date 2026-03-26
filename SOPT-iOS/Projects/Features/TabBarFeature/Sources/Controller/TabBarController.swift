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
    
    private let viewWillAppear = PassthroughSubject<Void, Never>()
    private let isTabBarItemSelected = PassthroughSubject<Int, Never>()
    private let userType: UserType
    private let cancelBag = CancelBag()
    
    private var tabTypes: [TabBarItemType] {
        switch userType {
        case .active, .inactive:
            return [.home, .soptamp, .poke, .soptlog]
        case .visitor:
            return [.home, .soptlog]
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppear.send()
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
        tabTypes.enumerated().forEach { index, tabType in
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
            viewWillAppear: viewWillAppear.asDriver(),
            isTabSelectedIndex: isTabBarItemSelected.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.selectedIndex
            .withUnretained(self)
            .sink { owner, index in
                owner.selectedIndex = index
            }.store(in: cancelBag)
        viewModel.$tabBarBadges
        
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, badges in
                owner.updateBadges(with: badges)
            }.store(in: cancelBag)
    }
    
    private func setDelegate() {
        self.delegate = self
    }

    private func updateBadges(with badges: [TabBarItemType: String]) {
        guard let items = tabBar.items else { return }
        
        tabTypes.enumerated().forEach { index, tabType in
            guard index < items.count else { return }
            let item = items[index]
            
            if let badgeText = badges[tabType] {
                item.badgeColor = DSKitAsset.Colors.orange400.color
                item.setBadgeTextAttributes([
                    .font: DSKitFontFamily.Suit.semiBold.font(size: 10),
                    .foregroundColor: DSKitAsset.Colors.gray900.color
                ], for: .normal)
                item.badgeValue = badgeText
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        isTabBarItemSelected.send(index)
    }
}

