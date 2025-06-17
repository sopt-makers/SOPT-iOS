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
    private let fabMenuSections = FABMenuSection.allCases
    
    private let isTabBarItemSelected = PassthroughSubject<Int, Never>()
    private let isMenuCellTapped = PassthroughSubject<String, Never>()
    private lazy var isFABTapped = plusButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    private let cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let plusButton = UIButton().then{
        $0.setImage(DSKitAsset.Assets.icFabPlus.image, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 18
        $0.imageView?.contentMode = .center
        $0.imageView?.clipsToBounds = false
    }
    
    private let dimmedView = UIView().then{
        $0.backgroundColor = DSKitAsset.Colors.black100.color.withAlphaComponent(0.6)
    }
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = self.createLayout()
        layout.register(FABMenuDecorationView.self, forDecorationViewOfKind: FABMenuDecorationView.className)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
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
        
        setUI()
        setLayout()
        bindViewModels()
        setAddTarget()
        
        configureTabBar()
        configureTabBarItem()
        
        setDelegate()
        configureCollectionView()
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
    private func setUI() {
        dimmedView.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(dimmedView, plusButton, menuCollectionView)
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.bottom.equalToSuperview().inset(58)
            make.centerX.equalToSuperview()
        }
        
        menuCollectionView.snp.makeConstraints { make in
            make.height.equalTo(299)
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(107)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
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
}

// MARK: - Methods

extension TabBarController {
    private func bindViewModels() {
        let input = TabBarViewModel.Input(
            isTabSelectedIndex: isTabBarItemSelected.asDriver(),
            isFABTapped: isFABTapped,
            isMenuCellTapped: isMenuCellTapped.asDriver()
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
    
    private func setDelegate() {
        self.delegate = self
    }
    
    private func configureCollectionView() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.register(FABMenuCVC.self, forCellWithReuseIdentifier: FABMenuCVC.className)
        menuCollectionView.register(FABMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FABMenuHeaderView.className)
    }
    
    private func setAddTarget() {
        plusButton.addTarget(self, action: #selector(FABAnimation), for: .touchUpInside)
    }
}

// MARK: - Animate

extension TabBarController {
    @objc
    private func FABAnimation(_ isTapped: Bool) {
        animatePlusButton(isTapped)
        animateDimmedView(isTapped)
        isTapped ? animateFABMenuIn() : animateFABMenuOut()
    }
    
    private func animatePlusButton(_ isTapped: Bool) {
        UIView.animate(withDuration: 0.6) {
            self.plusButton.imageView?.transform = isTapped ? .init(rotationAngle: -CGFloat.pi/4) : .identity
        }
    }
    
    private func animateFABMenuIn() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.75,
                       options: [.curveEaseInOut],
                       animations: {
            let positionY = self.view.frame.maxY - self.plusButton.frame.minY + 16 + self.menuCollectionView.frame.height
            self.menuCollectionView.transform = CGAffineTransform(translationX: 0, y: -positionY)
        })
    }
    
    private func animateFABMenuOut() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {
            self.menuCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    private func animateDimmedView(_ isTapped: Bool) {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.75,
                       options: [.curveEaseInOut],
                       animations: {
            self.dimmedView.isHidden = !isTapped
            self.dimmedView.alpha = isTapped ? 1 : 0
        })
    }
}


// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        isTabBarItemSelected.send(index)
    }
}

// MARK: - UICollectionView

extension TabBarController: UICollectionViewDelegateFlowLayout { }

extension TabBarController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fabMenuSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fabMenuSections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FABMenuCVC.className, for: indexPath) as? FABMenuCVC else { return UICollectionViewCell() }
        
        cell.configureCell(model: fabMenuSections[indexPath.section].items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: FABMenuHeaderView.className,
                                              for: indexPath) as? FABMenuHeaderView
        else { return UICollectionReusableView() }
        
        headerView.configureCell(title: fabMenuSections[indexPath.section].title)
        return headerView
    }
}

extension TabBarController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = fabMenuSections[indexPath.section].items[indexPath.item].url
        self.isMenuCellTapped.send(url)
    }
}
