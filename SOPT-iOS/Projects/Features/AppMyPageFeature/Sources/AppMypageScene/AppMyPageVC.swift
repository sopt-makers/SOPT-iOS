//
//  AppMyPageVC.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine
import SafariServices
import SnapKit
import Then

import Core
import DSKit
import BaseFeatureDependency

public final class AppMyPageVC: UIViewController, MyPageViewControllable {
    
    // MARK: - Properties
    
    private let viewModel: AppMyPageViewModel
    private let userType: UserType
    private var dataSource: UICollectionViewDiffableDataSource<MyPageSectionLayoutKind, MyPageItem>! = nil
    private var cellTapped = PassthroughSubject<MyPageItem, Never>()
    private let cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: DSKitAsset.Colors.black100.color,
        ignoreLeftButtonAction: true
    )
        .addMiddleLabel(title: I18N.MyPage.navigationTitle)
    
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setRegister()
        setDataSource()
        applySnapshot()
        bindViewModels()
    }
//    
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.setGestureDelegate()
//    }
    
    public init(userType: UserType, viewModel: AppMyPageViewModel) {
        self.userType = userType
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppMyPageVC {
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        view.addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(13)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setRegister() {
        collectionView.collectionViewLayout.register(MyPageSectionBackgroundView.self, forDecorationViewOfKind: MyPageSectionBackgroundView.className)
        collectionView.register(MyPageSectionHeaderView.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageSectionHeaderView.className)
    }
    
    private func setDataSource() {
        let myPageMenuRegistration = createMyPageeCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<MyPageSectionLayoutKind, MyPageItem> (collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: myPageMenuRegistration, for: indexPath, item: item)
        })
        
        configureSupplementaryView()
    }
    
    private func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
            
            return UICollectionReusableView()
        }
    }
    
    private func makeSections(for userType: UserType) -> [MyPageSectionLayoutKind] {
        switch userType {
        case .visitor:
            return [.servicePolicy, .etcVisitor]
        default:
            return [.servicePolicy, .notificationSettings, .soptampSettings, .etcUser]
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MyPageSectionLayoutKind, MyPageItem>()
        
        let sections = makeSections(for: self.userType)
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension AppMyPageVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        cellTapped.send(item)
    }
}

// MARK: - Methods

extension AppMyPageVC {
    private func bindViewModels() {
        let input = AppMyPageViewModel.Input(
            naviBackButtonTapped: navigationBar.leftButtonTapped.asDriver(),
            cellTapped: cellTapped.asDriver()
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.resetSuccessed
            .filter { $0 }
            .withUnretained(self)
            .sink { owner, _ in
                Toast.show(message: I18N.MyPage.resetSuccess, view: owner.view)
            }.store(in: self.cancelBag)
        
    }
}
