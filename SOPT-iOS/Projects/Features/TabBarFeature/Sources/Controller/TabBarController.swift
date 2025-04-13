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
    private lazy var isFABTapped = plusButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    private let cancelBag = CancelBag()
    
    private let plusButton = UIButton().then{
        $0.setImage(DSKitAsset.Assets.icFabPlus.image, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 18
        $0.imageView?.contentMode = .center
        $0.imageView?.clipsToBounds = false
    }
    
    // MARK: - Life Cycle
    
    init(viewModel: TabBarViewModel, tabList: [UIViewController]) {
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
        bindViewModels()
        setLayout()
        setAddTarget()
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
    private func setLayout() {
        view.addSubviews(plusButton)
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.bottom.equalToSuperview().inset(58)
            make.centerX.equalToSuperview()
        }
    }
    
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
        TabBarItemType.allCases.forEach {
            tabList[$0.rawValue].tabBarItem = $0.makeTabBarItem()
            tabList[$0.rawValue].tabBarItem.tag = $0.rawValue
            tabList[$0.rawValue].tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            tabList[$0.rawValue].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
            tabList[$0.rawValue].tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: DSKitFontFamily.Suit.medium.font(size: 10)], for: .normal)
        }

        setViewControllers(tabList, animated: true)
    }
    
    @objc
    private func FABAnimation(_ isTapped: Bool) {
        UIView.animate(withDuration: 0.6) {
            self.plusButton.imageView?.transform = isTapped ? .init(rotationAngle: -CGFloat.pi/4) : .identity
        }
    }
}

// MARK: - Methods

extension TabBarController {
    private func setDelegate() {
        self.delegate = self
    }
    
    private func bindViewModels() {
        let input = TabBarViewModel.Input(
            isTabSelectedIndex: isTabBarItemSelected.asDriver(), 
            isFABTapped: isFABTapped
        )
    
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.selectedIndex
            .withUnretained(self)
            .sink { owner, index in
                owner.selectedIndex = index
            }.store(in: cancelBag)
        
        viewModel.$isFABTapped
            .withUnretained(self)
            .sink { owner, bool in
                owner.FABAnimation(bool)
            }.store(in: cancelBag)
    }
    
    private func setAddTarget() {
        plusButton.addTarget(self, action: #selector(FABAnimation), for: .touchUpInside)
    }
}


// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        isTabBarItemSelected.send(index)
    }
}
