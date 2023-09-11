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

    // MARK: - Properties
    
    public var viewModel: NotificationListViewModel
    private var cancelBag = CancelBag()
    private var cellTapped = PassthroughSubject<Int, Never>()
    private var requestNotifications = CurrentValueSubject<Void, Never>(())
    
    private var notificationFilterDataSource: UICollectionViewDiffableDataSource<Int, NotificationFilterType>!
    
    private var notificationListdataSource: UICollectionViewDiffableDataSource<Int, NotificationListModel>!
    
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(self, type: .bothButtons, ignoreLeftButtonAction: true)
        .addMiddleLabel(title: I18N.Notification.notification)
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
    
    // MARK: - initialization
    
    public init(viewModel: NotificationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModels()
        self.setDelegate()
        self.setDataSource()
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
        }
    }
    
    private func setDataSource() {
        self.notificationFilterDataSource = UICollectionViewDiffableDataSource(collectionView: notificationFilterCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationFilterCVC.className,
                                                                for: indexPath) as? NotificationFilterCVC
            else { return UICollectionViewCell() }
            
            cell.initCell(type: itemIdentifier)
            return cell
        })
        
        
        self.notificationListdataSource = UICollectionViewDiffableDataSource(collectionView: notificationListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationListCVC.className,
                                                                for: indexPath) as? NotificationListCVC
            else { return UICollectionViewCell() }
            
            let notification = itemIdentifier
            
            cell.initCell(title: notification.title,
                          time: notification.createdAt,
                          description: notification.content,
                          isUnread: notification.isRead)
            return cell
        })
    }
    
    private func applyNotificationFilterSnapshot(model: [NotificationFilterType]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NotificationFilterType>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(model)
        notificationFilterDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyNotificationListSnapshot(model: [NotificationListModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NotificationListModel>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(model)
        notificationListdataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setCollectionViews() {
        registerCells()
    }
    
    private func registerCells() {
        self.notificationFilterCollectionView.register(NotificationFilterCVC.self, forCellWithReuseIdentifier: NotificationFilterCVC.className)
        self.notificationListCollectionView.register(NotificationListCVC.self, forCellWithReuseIdentifier: NotificationListCVC.className)
    }
    
    /// 초기 값으로 "모든 알림"을 선택한다.
    private func selectDefaultFilter() {
        guard notificationFilterCollectionView.numberOfSections >= 1 else { return }
        
        notificationFilterCollectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                                        animated: false,
                                                        scrollPosition: .left)
    }
}

// MARK: - Methods

extension NotificationListVC {
    private func bindViewModels() {
        let input = NotificationListViewModel.Input(
            requestNotifications: requestNotifications.asDriver(),
            naviBackButtonTapped: naviBar.leftButtonTapped,
            cellTapped: cellTapped.asDriver(),
            readAllButtonTapped: naviBar.rightButtonTapped
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.filterList
            .sink { [weak self] filterList in
                self?.applyNotificationFilterSnapshot(model: filterList)
                self?.selectDefaultFilter()
            }.store(in: self.cancelBag)
        
        output.notificationList
            .sink { [weak self] notificationList in
                self?.applyNotificationListSnapshot(model: notificationList)
            }.store(in: self.cancelBag)
    }
}

// MARK: - UICollectionViewDelegate

extension NotificationListVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == notificationListCollectionView {
            cellTapped.send(indexPath.item)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        guard offsetY > 0 else { return }
        
        if height > contentHeight - offsetY && !viewModel.isPaging {
            viewModel.startPaging()
            requestNotifications.send(())
        }
    }
}
