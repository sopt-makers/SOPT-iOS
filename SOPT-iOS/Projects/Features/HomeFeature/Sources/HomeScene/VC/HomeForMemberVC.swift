//
//  HomeForMemberVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency

final class HomeForMemberVC: UIViewController, HomeForMemberViewControllable {
    
    // MARK: - Properties
    
    public let viewModel: HomeForMemberViewModel
    private(set) var cancelBag = CancelBag()
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    private var cellTapped = PassthroughSubject<HomeForMemberItem, Never>()
    private(set) var attendanceButtonTapped = PassthroughSubject<Void, Never>()
    
    private var fabButtonTapped = PassthroughSubject<Void, Never>()
    private lazy var extendedFAButtonTapped = FAButton.actionButtonTapped
    private lazy var collapsedFAButtonTapped = FAButton.gesture().mapVoid().asDriver()
    
    private var isFirstAppear = true
    private var isExtendedButtonHidden: Bool = false
    private var fabButtonType: ExtendedFAButtonType = .extended
    
    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar()
    private var dataSource: UICollectionViewDiffableDataSource<HomeForMemberSectionLayoutKind, HomeForMemberItem>! = nil
    var collectionView: UICollectionView! = nil
    private var FAButton = HomeFAButton(frame: .zero)
    
    // MARK: - Initialization
    
    public init(viewModel: HomeForMemberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setUI()
        setLayout()
        setDelegate()
        setDataSource()
        bindViews()
        bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppear.send()
    }
}

// MARK: - UI & Layout

extension HomeForMemberVC {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
    }
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        self.FAButton.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(
            naviBar,
            collectionView,
            FAButton
        )
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        FAButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(124)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }
    }
    
    private func extendedFAButtonLayout() {
        FAButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(124)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }
    }
    
    private func collapsedFAButtonLayout() {
        FAButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(124)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(127)
            make.height.equalTo(53)
        }
    }
    
    private func animateExtendedFAButtonHide(_ type: ExtendedFAButtonType) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
            guard let self else { return }
            self.FAButton.transform = CGAffineTransform(translationX: 0, y: 120)
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.animateExtendedFAButtonShow()
            
            type == .extended ? self.FAButton.setStyle(.collapsed) : self.FAButton.setStyle(.extended)
            type == .extended ? self.collapsedFAButtonLayout() : self.extendedFAButtonLayout()
            
        })
    }
    
    private func animateExtendedFAButtonShow() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
            guard let self else { return }
            self.FAButton.transform = .identity
        })
    }
}

// MARK: - Methods

extension HomeForMemberVC {
    private func setDelegate() {
        self.collectionView.delegate = self
    }
    
    private func setDataSource() {
        let dashBoardRegistration = createDashBoardCellRegistration()
        let calendarRegistration = createCalendarCellRegistration()
        let mainProductRegistration = createProductCellRegistration()
        let appServiceRegistration = createAppServiceCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<HomeForMemberSectionLayoutKind, HomeForMemberItem> (
            collectionView: collectionView) { (collectionView, indexPath, item) in
                switch item {
                case .dashBoard(let dashBoard):
                    return collectionView.dequeueConfiguredReusableCell(using: dashBoardRegistration,
                                                                        for: indexPath, item: dashBoard)
                case .recentSchedule(let schedule):
                    return collectionView.dequeueConfiguredReusableCell(using: calendarRegistration,
                                                                        for: indexPath, item: schedule)
                case .productService(let productService):
                    return collectionView.dequeueConfiguredReusableCell(using: mainProductRegistration,
                                                                        for: indexPath, item: productService)
                case .appService(let appService):
                    return collectionView.dequeueConfiguredReusableCell(using: appServiceRegistration,
                                                                        for: indexPath, item: appService)
                default: return UICollectionViewCell()
                }
            }
        
        configureSupplementaryView()
    }
    
    private func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
            return UICollectionReusableView()
        }
    }
    
    private func bindViews() {
        self.extendedFAButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                if owner.fabButtonType == .extended {
                    owner.fabButtonTapped.send()
                }
            }.store(in: cancelBag)
        
        self.collapsedFAButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                if owner.fabButtonType == .collapsed {
                    owner.fabButtonTapped.send()
                }
            }.store(in: cancelBag)
    }
    
    private func bindViewModels() {
        let noticeButtonTapped = naviBar.noticeButtonTap.mapVoid().asDriver()
        let settingButtonTapped = naviBar.settingButtonTap.mapVoid().asDriver()
        
        let input = HomeForMemberViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            viewWillAppear: viewWillAppear.asDriver(),
            cellTapped: cellTapped.asDriver(),
            attendanceButtonTapped: attendanceButtonTapped.asDriver(),
            noticeButtonTapped: noticeButtonTapped,
            settingButtonTapped: settingButtonTapped,
            extendedFAButtonTapped: fabButtonTapped.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.homeItem
            .withUnretained(self)
            .sink { owner, data in
                owner.updateUI(with: data)
            }.store(in: cancelBag)
        
        output.isLoading
            .withUnretained(self)
            .sink { owner, isLoading in
                isLoading ? owner.showLoading() : owner.stopLoading()
            }.store(in: cancelBag)
        
        output.fabButtonInfo
            .withUnretained(self)
            .sink { owner, fabModel in
                owner.FAButton.isHidden = false
                owner.FAButton.configureUI(with: fabModel)
            }.store(in: cancelBag)
    }
    
    private func updateUI(with data: HomePresentationModel) {
        if isFirstAppear {
            applySnapshot(with: data)
            isFirstAppear = false
        } else {
            setItemsNeedUpdate(data)
        }
        updateNaviBarUI(isAllConfirm: data.dashBoard.isAllConfirm)
    }
    
    private func updateNaviBarUI(isAllConfirm: Bool?) {
        if let isAllConfirm = isAllConfirm {
            self.naviBar.changeNoticeButtonStyle(isActive: !isAllConfirm)
        }
    }
    
    private func applySnapshot(with data: HomePresentationModel) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeForMemberSectionLayoutKind, HomeForMemberItem>()
        
        snapshot.appendSections([.dashBoard, .calendar, .mainProduct, .appService])
        
        snapshot.appendItems([.dashBoard(data.dashBoard)], toSection: .dashBoard)
        snapshot.appendItems([.recentSchedule(data.recentSchedule)], toSection: .calendar)
        snapshot.appendItems(self.viewModel.productServiceList.map { .productService($0) }, toSection: .mainProduct)
        snapshot.appendItems(data.appServices.map { .appService($0) }, toSection: .appService)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setItemsNeedUpdate(_ data: HomePresentationModel) {
        var snapshot = self.dataSource.snapshot()
        
        let items: [HomeForMemberItem] = [
            .dashBoard(data.dashBoard),
            .recentSchedule(data.recentSchedule)
        ] + data.appServices.map { .appService($0) }
        
        let existingItems = snapshot.itemIdentifiers.filter { items.contains($0) }
        
        if !existingItems.isEmpty {
            snapshot.reconfigureItems(existingItems)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeForMemberVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            switch selectedItem {
            case .dashBoard(let model):
                self.cellTapped.send(.dashBoard(model))
            case .recentSchedule(let model):
                self.cellTapped.send(.recentSchedule(model))
            case .productService(let model):
                self.cellTapped.send(.productService(model))
            case .appService(let model):
                self.cellTapped.send(.appService(model))
            default: return
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 330 && isExtendedButtonHidden || offsetY >= 330 && !isExtendedButtonHidden {
            toggleFAButtonUI()
        }
    }
    
    /// offsetY 값이 330을 지날 때 FAB의 UI를 변경하고 애니메이션을 실행하는 메서드
    private func toggleFAButtonUI() {
        animateExtendedFAButtonHide(fabButtonType)
        isExtendedButtonHidden.toggle()
        fabButtonType = fabButtonType == .extended ? .collapsed : .extended
        FAButton.layoutIfNeeded()
    }
}
