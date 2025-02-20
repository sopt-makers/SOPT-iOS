//
//  TabBarItem.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class TabBarController: UITabBarController {
    
    private let tabList: [UINavigationController]
    private let viewModel: TabBarViewModel
    
    
    init(viewModel: TabBarViewModel, tabList: [UINavigationController]) {
        self.viewModel = viewModel
        self.tabList = tabList
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureTabBarItem()
        setDelegate()
    }
    
    override public func viewDidLayoutSubviews() {
        configureTabBarHeight()
    }
}

extension TabBarController {
    private func configureTabBar() {
        UITabBar.clearShadow()
        view.tintColor = .white
        tabBar.backgroundColor = DSKitAsset.Colors.gray800.color
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    /// setting tabbar height
    private func configureTabBarHeight() {
        var tabFrame = tabBar.frame
        tabFrame.size.height = 72
        tabFrame.origin.y = view.frame.size.height - tabFrame.size.height
        
        tabBar.frame = tabFrame
    }
    
    private func configureTabBarItem() {
        TabBarItem.allCases.forEach {
            tabList[$0.rawValue].tabBarItem = $0.makeTabBarItem()
            tabList[$0.rawValue].tabBarItem.tag = $0.rawValue
            tabList[$0.rawValue].tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 0, bottom: -18, right: 0)
        }

        setViewControllers(tabList, animated: true)
    }
    
    private func setDelegate() {
        self.delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.selectedIndex = selectedIndex
    }
}
