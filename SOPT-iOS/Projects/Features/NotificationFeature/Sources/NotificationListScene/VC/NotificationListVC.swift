//
//  NotificationListVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine

import BaseFeatureDependency
import NotificationFeatureInterface

public final class NotificationListVC: UIViewController, NotificationListViewControllable {
    
    public typealias factoryType = NotificationFeatureViewBuildable
    & AlertViewBuildable

    // MARK: - Properties
    
    public var viewModel: NotificationListViewModel!
    public var factory: factoryType!
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    lazy var naviBar = OPNavigationBar(self, type: .bothButtons)
        .addRightButton(with: nil)
        .addRightButton(with: I18N.Notification.readAll, titleColor: DSKitAsset.Colors.purple100.color)
    
    private lazy var notificationFilterCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createFilterCollectionViewLayout())
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var notificationListCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createListCollectionViewLayout())
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let emptyView: NotificationEmptyView = {
        let view = NotificationEmptyView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModels()
        self.setDelegate()
        self.setCollectionViews()
    }
}

// MARK: - UI & Layout

extension NotificationListVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, notificationFilterCollectionView, notificationListCollectionView)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        notificationFilterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(46)
        }
        
        notificationListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(notificationFilterCollectionView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        notificationListCollectionView.addSubviews(emptyView)
        
        emptyView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setDelegate() {
        [notificationFilterCollectionView, notificationListCollectionView].forEach { collectionView in
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    private func setCollectionViews() {
        registerCells()
        // 초기 값으로 "모든 알림"을 선택한다.
        notificationFilterCollectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                                    animated: false,
                                                    scrollPosition: .left)
    }
    
    private func registerCells() {
        self.notificationFilterCollectionView.register(NotificationFilterCVC.self, forCellWithReuseIdentifier: NotificationFilterCVC.className)
        self.notificationListCollectionView.register(NotificationListCVC.self, forCellWithReuseIdentifier: NotificationListCVC.className)
    }
}

// MARK: - Methods

extension NotificationListVC {
    private func bindViewModels() {
    }
}

// MARK: - UICollectionViewDelegate

extension NotificationListVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension NotificationListVC: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.notificationFilterCollectionView {
            return viewModel.filterList.count
        } else {
            return 10
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.notificationFilterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationFilterCVC.className,
                                                                for: indexPath) as? NotificationFilterCVC
            else { return UICollectionViewCell() }
            
            cell.initCell(type: viewModel.filterList[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationListCVC.className,
                                                                for: indexPath) as? NotificationListCVC
            else { return UICollectionViewCell() }
            
            cell.initCell(title: "[GO SOPT] 32기 전체 회계 공지", time: "1주일 전", description: "안녕하세요. 안녕하세요. 안녕하세요. 안녕하세요. 안녕하세요. 안녕하세요.", isUnread: true)
            return cell
        }
    }
}
