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
    private let isMenuCellTapped = PassthroughSubject<String, Never>()
    private let userType: UserType
    private let cancelBag = CancelBag()
    private let fabMenuSections = FABMenuSection.allCases
    
    private lazy var isFABTapped = plusButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    
    private var tabTypes: [TabBarItemType] {
        switch userType {
        case .active, .inactive:
            return [.home, .soptamp, .poke, .soptlog]
        case .visitor:
            return [.home, .soptlog]
        }
    }
    
    // MARK: - UI Components
    
    private let plusButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icFabPlus.image, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 18
        $0.imageView?.contentMode = .center
        $0.imageView?.clipsToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 10
    }
    
    private let dimmedView = UIView().then{
        $0.backgroundColor = DSKitAsset.Colors.black100.color.withAlphaComponent(0.6)
        $0.isHidden = true
    }
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = self.createFABLayout()
        layout.register(FABMenuDecorationView.self, forDecorationViewOfKind: FABMenuDecorationView.className)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
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
        
        setUI()
        setLayout()
        
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
        
        plusButton.frame = CGRect(
            x: tabBar.frame.maxX - 19 - 48,
            y: tabBar.frame.minY + 10,
            width: 48,
            height: 48
        )
    }
    
    deinit {
        self.delegate = nil
    }
}

// MARK: - UI & Layout

extension TabBarController {
    private func setUI() {
        view.addSubviews(dimmedView, plusButton, menuCollectionView)
    }
    
    private func setLayout() {
        dimmedView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        
        menuCollectionView.snp.makeConstraints { make in
            make.height.equalTo(299)
            make.top.equalTo(view.snp.bottom)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(160)
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
        let dummyVC = UIViewController()
        dummyVC.tabBarItem = UITabBarItem(title: nil, image: nil, tag: tabTypes.count)
        
        var tabListWithDummy = tabList
        tabListWithDummy.append(dummyVC)
        
        tabTypes.enumerated().forEach { index, tabType in
            let viewController = tabListWithDummy[index]
            viewController.tabBarItem = tabType.makeTabBarItem()
            viewController.tabBarItem.tag = index
            viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
            viewController.tabBarItem.setTitleTextAttributes(
                [NSAttributedString.Key.font: DSKitFontFamily.Suit.medium.font(size: 10)],
                for: .normal
            )
        }
        
        setViewControllers(tabListWithDummy, animated: true)
    }
}

// MARK: - Methods

extension TabBarController {
    
    private func bindViewModels() {
        let input = TabBarViewModel.Input(
            viewWillAppear: viewWillAppear.asDriver(),
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
        
        viewModel.$tabBarBadges
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, badges in
                owner.updateBadges(with: badges)
            }.store(in: cancelBag)
        
        viewModel.$isFABTapped
            .withUnretained(self)
            .sink { owner, bool in
                owner.FABAnimation(bool)
            }.store(in: cancelBag)
    }
    
    private func setDelegate() {
        self.delegate = self
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.register(FABMenuCVC.self, forCellWithReuseIdentifier: FABMenuCVC.className)
        menuCollectionView.register(FABMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FABMenuHeaderView.className)
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController.tabBarItem.tag != tabTypes.count
    }
}

// MARK: - Animate

extension TabBarController {
    private func animatePlusButton(_ isTapped: Bool) {
        UIView.animate(withDuration: 0.6) {
            self.plusButton.imageView?.transform = isTapped ? .init(rotationAngle: -CGFloat.pi/4) : .identity
        }
    }
    
    @objc
    private func FABAnimation(_ isTapped: Bool) {
        animatePlusButton(isTapped)
        animateDimmedView(isTapped)
        isTapped ? animateFABMenuIn() : animateFABMenuOut()
    }
    
    private func animateDimmedView(_ isTapped: Bool) {
        if isTapped { self.dimmedView.isHidden = false }
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.75,
                       options: [.curveEaseInOut],
                       animations: {
            self.dimmedView.alpha = isTapped ? 1 : 0
        }) { _ in
            if !isTapped { self.dimmedView.isHidden = true }
        }
    }
    
    private func animateFABMenuIn() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.75,
                       options: [.curveEaseInOut],
                       animations: {
            let positionY = self.view.frame.maxY - self.plusButton.frame.minY + 20 + self.menuCollectionView.frame.height
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
}

// MARK: - Create FAB Layout

extension TabBarController {
    private enum Metric {
        static let collectionViewDefaultInset: Double = 14
        static let collectionViewTopInset: Double = 10
        static let collectionViewBottonInset: Double = 22
        
        static let sectionTitleTopInset: Double = 12
        static let sectionInterSpacing: Double = 8
    }
    
    func createFABLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, evn in
            switch section {
            default:
                return self?.createFABMenuSection()
            }
        }
    }
    
    private func createFABMenuSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        /// 섹션 별 헤더
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(15))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: -Metric.sectionTitleTopInset,
                                                              leading: 0,
                                                              bottom: 0,
                                                              trailing: 0)
        
        /// 섹션 데코레이션 아이템
        let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: FABMenuDecorationView.className)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.decorationItems = [backgroundView]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: Metric.collectionViewDefaultInset,
                                                        bottom: Metric.collectionViewBottonInset,
                                                        trailing: Metric.collectionViewDefaultInset)
        
        return section
    }
}

extension TabBarController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = fabMenuSections[indexPath.section].items[indexPath.item].url
        self.isMenuCellTapped.send(url)
    }
}
