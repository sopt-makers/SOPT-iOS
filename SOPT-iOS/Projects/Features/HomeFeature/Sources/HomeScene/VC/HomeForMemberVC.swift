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
    
    private var floatingButtonTapped = PassthroughSubject<Void, Never>()
    private lazy var extendedFloatingButtonTapped = floatingButton.actionButtonTapped
    private lazy var collapsedFloatingButtonTapped = floatingButton.gesture().mapVoid().asDriver()
    private(set) var surveyButtonTapped = PassthroughSubject<Void, Never>()
    private(set) var viewAllButtonTapped = PassthroughSubject<Void, Never>()
    private var socialLinkButtonTapped = PassthroughSubject<HomePresentationModel.SocialLink, Never>()
    private(set) var profileImageViewTapped = PassthroughSubject<Int, Never>()
    
    private var isFirstAppear = true
    private var isExtendedButtonHidden: Bool = false
    private var hasStartedAnimation = false
    var isOutlineAnimationStopped = false
    private var floatingButtonType: ExtendedFloatingButtonType = .extended
    var latestPostAnimationTask: Task<Void, Never>?
    var fetchDataTask: Task<Void, Never>?
    
    var outlineAnimationTimer: Timer?
    var currentIndex = 0
    
    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar()
    var dataSource: UICollectionViewDiffableDataSource<HomeForMemberSectionLayoutKind, HomeForMemberItem>! = nil
    var collectionView: UICollectionView! = nil
    private var floatingButton = HomeFloatingButton(frame: .zero)
    
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
        fetchData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopLatestPostAnimationLoop()
        cancelTasks()
        stopPopularPostsAnimationLoop()
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
        self.floatingButton.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(
            naviBar,
            collectionView,
            floatingButton
        )
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(124)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }
    }
    
    private func extendedFloatingButtonLayout() {
        floatingButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(124)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }
    }
    
    private func collapsedFloatingButtonLayout() {
        floatingButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(124)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(127)
            make.height.equalTo(53)
        }
    }
    
    private func animateExtendedFloatingButtonHide(_ type: ExtendedFloatingButtonType) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
            guard let self else { return }
            self.floatingButton.transform = CGAffineTransform(translationX: 0, y: 120)
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.animateExtendedFloatingButtonShow()
            
            type == .extended ? self.floatingButton.setStyle(.collapsed) : self.floatingButton.setStyle(.extended)
            type == .extended ? self.collapsedFloatingButtonLayout() : self.extendedFloatingButtonLayout()
            
        })
    }
    
    private func animateExtendedFloatingButtonShow() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
            guard let self else { return }
            self.floatingButton.transform = .identity
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
        let popularPostRegistration = createPopularPostCellRegistration()
        let latestPostRegistration = createLatestPostCellRegistration()
        let surveyRegistration = createSurveyRegistration()
        let socialLinkRegistration = createSocialLinkCellRegistration()
        
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
                case .popularPost(let popularPost):
                    return collectionView.dequeueConfiguredReusableCell(using: popularPostRegistration,
                                                                        for: indexPath, item: popularPost)
                case .latestPost(let latestPost):
                    return collectionView.dequeueConfiguredReusableCell(using: latestPostRegistration,
                                                                        for: indexPath, item: latestPost)
                case .survey(let survey):
                    return collectionView.dequeueConfiguredReusableCell(using: surveyRegistration,
                                                                        for: indexPath, item: survey)
                case .socialLink(let socialLink):
                    return collectionView.dequeueConfiguredReusableCell(using: socialLinkRegistration,
                                                                        for: indexPath, item: socialLink)
                }
            }
        
        configureSupplementaryView()
    }
    
    private func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        let latestPostFooterRegistration = createLatestPostFooterRegistration()
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionKind = HomeForMemberSectionLayoutKind(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            }
            
            if kind == UICollectionView.elementKindSectionFooter && sectionKind == .latestPosts {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: latestPostFooterRegistration,
                    for: indexPath
                )
            }
            
            return nil
        }
    }
    
    private func bindViews() {
        self.extendedFloatingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                if owner.floatingButtonType == .extended {
                    owner.floatingButtonTapped.send()
                }
            }.store(in: cancelBag)
        
        self.collapsedFloatingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                if owner.floatingButtonType == .collapsed {
                    owner.floatingButtonTapped.send()
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
            extendedFloatingButtonTapped: floatingButtonTapped.asDriver(),
            surveyButtonTapped: surveyButtonTapped.asDriver(),
            socialLinkButtonTapped: socialLinkButtonTapped.asDriver(),
            viewAllButtonTapped: viewAllButtonTapped.asDriver(),
            profileImageViewTapped: profileImageViewTapped.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.isLoading
            .withUnretained(self)
            .sink { owner, isLoading in
                isLoading ? owner.showLoading() : owner.stopLoading()
            }.store(in: cancelBag)
        
        output.floatingButtonInfo
            .withUnretained(self)
            .sink { owner, floatingButtonModel in
                owner.floatingButton.isHidden = false
                owner.floatingButton.configureUI(with: floatingButtonModel)
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
        
        snapshot.appendSections([.dashBoard, .calendar, .mainProduct, .appService, .popularPosts, .latestPosts, .survey, .socialLinks])
        
        snapshot.appendItems([.dashBoard(data.dashBoard)], toSection: .dashBoard)
        snapshot.appendItems([.recentSchedule(data.recentSchedule)], toSection: .calendar)
        snapshot.appendItems(self.viewModel.productServiceList.map { .productService($0) }, toSection: .mainProduct)
        snapshot.appendItems(data.appServices.map { .appService($0) }, toSection: .appService)
        snapshot.appendItems(data.popularPosts.map { .popularPost($0) }, toSection: .popularPosts)
        snapshot.appendItems(data.latestPosts.map { .latestPost($0) }, toSection: .latestPosts)
        snapshot.appendItems([.survey(data.survey)], toSection: .survey)
        snapshot.appendItems(self.viewModel.socialLinkList.map { .socialLink($0) }, toSection: .socialLinks)

        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            // 애니메이션은 data가 apply된 이후에 실행
            self?.startPopularPostsAnimationLoop()
            self?.startLatestPostAnimationLoop()
        }
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
            self.dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
                self?.startPopularPostsAnimationLoop()
                self?.startLatestPostAnimationLoop()
            }
        }
    }
    
    private func cancelTasks() {
        self.fetchDataTask?.cancel()
        self.fetchDataTask = nil
    }
    
    private func fetchData() {
        cancelTasks()
        
        fetchDataTask = Task { [weak self] in
            guard let self else { return }
            if let data = await self.viewModel.fetchHomeData() {
                updateUI(with: data)
            }
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
            case .popularPost(let model):
                self.cellTapped.send(.popularPost(model))
            case .latestPost(let model):
                self.cellTapped.send(.latestPost(model))
            case .socialLink(let model):
                self.cellTapped.send(.socialLink(model))
            default: return
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animateFAButton(scrollView)
        updateLatestPostPageControl()
    }
    
    private func animateFAButton(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 130 && isExtendedButtonHidden || offsetY >= 130 && !isExtendedButtonHidden {
            toggleFloatingButtonUI()
        }
    }
    
    /// offsetY 기준 값을 지날 때 floating button의 UI를 변경하고 애니메이션을 실행하는 메서드
    private func toggleFloatingButtonUI() {
        animateExtendedFloatingButtonHide(floatingButtonType)
        isExtendedButtonHidden.toggle()
        floatingButtonType = floatingButtonType == .extended ? .collapsed : .extended
        floatingButton.layoutIfNeeded()
    }
    
    /// Latest Post 섹션의 page control에 focusing된 값을 바꾸는 메서드
    private func updateLatestPostPageControl() {
        guard let footer = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter)
            .first(where: { ($0 as? LatestPostFooterView) != nil }) as? LatestPostFooterView else { return }
                
        if let visibleItems = self.collectionView.indexPathsForVisibleItems
            .filter({ $0.section == HomeForMemberSectionLayoutKind.latestPosts.rawValue })
            .sorted(by: { $0.item < $1.item })
            .first {
            footer.updatePage(currentPage: visibleItems.item)
        }
    }
}
