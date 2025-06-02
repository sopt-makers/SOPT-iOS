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
    
    // MARK: - Metric
    
    private enum Metric {
        static let navigationbarHeight = 44.f
        static let firstSectionGroupTop = 13.f
        static let sectionGroupLeadingTrailing = 20.f
        
        static let sectionGroupSpacing = 16.f
    }
    
    // MARK: - Properties
    
    private let viewModel: AppMyPageViewModel
    private let userType: UserType
    private var dataSource: UICollectionViewDiffableDataSource<MyPageSectionLayoutKind, MyPageItem>! = nil
    
    // MARK: - MyPageCoordinatable
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onPolicyItemTap: (() -> Void)?
    public var onTermsOfUseItemTap: (() -> Void)?
    public var onEditOnelineSentenceItemTap: (() -> Void)?
    public var onWithdrawalItemTap: ((UserType) -> Void)?
    public var onLoginItemTap: (() -> Void)?
    public var onShowLogin: (() -> Void)?
    public var onAlertButtonTap: ((String) -> Void)?
    
    // MARK: Combine
    private let resetButtonTapped = PassthroughSubject<Bool, Never>()
    private let logoutButtonTapped = PassthroughSubject<Void, Never>()
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
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGestureDelegate()
    }
    
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

extension AppMyPageVC: UICollectionViewDelegate {
}

//extension AppMyPageVC {
//    private func setupLayouts() {
//        self.view.addSubviews(self.navigationBar, self.scrollView)
//        self.scrollView.addSubview(self.contentStackView)
//
//        switch self.userType {
//        case .active, .inactive:
//            self.contentStackView.addArrangedSubviews(
//                self.servicePolicySectionGroup,
//                self.alertSectionGroup,
//                self.soptampSectionGroup,
//                self.etcSectionGroup
//            )
//        case .visitor:
//            self.contentStackView.addArrangedSubviews(
//                self.servicePolicySectionGroup,
//                self.etcForVisitorsSectionGroup
//            )
//        }
//    }
//
//    private func setupConstraints() {
//        self.navigationBar.snp.makeConstraints {
//            $0.height.equalTo(Metric.navigationbarHeight)
//            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            $0.leading.trailing.equalToSuperview()
//        }
//        self.scrollView.snp.makeConstraints {
//            $0.top.equalTo(self.navigationBar.snp.bottom)
//            $0.leading.trailing.bottom.equalToSuperview()
//        }
//        self.contentStackView.snp.makeConstraints {
//            $0.width.equalTo(self.view.frame.width - Metric.sectionGroupLeadingTrailing * 2)
//            $0.top.equalToSuperview().inset(Metric.firstSectionGroupTop)
//            $0.leading.trailing.equalToSuperview().inset(Metric.sectionGroupLeadingTrailing)
//            $0.bottom.equalToSuperview()
//        }
//    }
//
//    // TODO: - (@승호): 적절히 객체에 위임하기
//    private func addTabGestureOnListItems() {
//        self.servicePolicySectionGroup.addTapGestureRecognizer { [weak self] in
//            self?.onPolicyItemTap?()
//        }
//
//        self.termsOfUseListItem.addTapGestureRecognizer { [weak self] in
//            self?.onTermsOfUseItemTap?()
//        }
//
//        self.sendFeedbackListItem.addTapGestureRecognizer {
//            openExternalLink(urlStr: ExternalURL.KakaoTalk.serviceProposal)
//        }
//
//        self.alertListItem.addTapGestureRecognizer { [weak self] in
//            self?.onAlertButtonTap?(UIApplication.openSettingsURLString)
//        }
//
//        self.editOnelineSentenceListItem.addTapGestureRecognizer { [weak self] in
//            self?.onEditOnelineSentenceItemTap?()
//        }
//
//        self.resetStampListItem.addTapGestureRecognizer { [weak self] in
//            AlertUtils.presentAlertVC(
//                type: .titleDescription,
//                theme: .main,
//                title: I18N.MyPage.resetMissionTitle,
//                description: I18N.MyPage.resetMissionDescription,
//                customButtonTitle: I18N.MyPage.reset,
//                customAction: { [weak self] in
//                    self?.resetButtonTapped.send(true)
//                },
//                animated: true
//            )
//        }
//
//        self.logoutListItem.addTapGestureRecognizer { [weak self] in
//            AlertUtils.presentAlertVC(
//                type: .titleDescription,
//                theme: .main,
//                title: I18N.MyPage.logoutDialogTitle,
//                description: I18N.MyPage.logoutDialogDescription,
//                customButtonTitle: I18N.MyPage.logoutDialogGrantButtonTitle,
//                customAction: { [weak self] in
//                    self?.logoutButtonTapped.send()
//                },
//                animated: true
//            )
//        }
//
//        self.withDrawalListItem.addTapGestureRecognizer { [weak self] in
//            self?.onWithdrawalItemTap?(self?.userType ?? .visitor)
//        }
//
//        self.loginListItem.addTapGestureRecognizer { [weak self] in
//            self?.onShowLogin?()
//        }
//    }
//}
//
//extension AppMyPageVC {
//    private func bindViews() {
//        self.navigationBar
//            .leftButtonTapped
//            .withUnretained(self)
//            .sink { owner, _ in
//                owner.onNaviBackButtonTap?()
//            }.store(in: self.cancelBag)
//    }
//
//    private func bindViewModels() {
//        let input = AppMyPageViewModel.Input(
//            resetButtonTapped: self.resetButtonTapped.asDriver(),
//            logoutButtonTapped: self.logoutButtonTapped.asDriver()
//        )
//        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
//
//        output.originNotificationIsAllowed
//            .withUnretained(self)
//            .sink { owner, isAllowed in
//                owner.alertListItem.configureSwitch(to: isAllowed)
//            }.store(in: self.cancelBag)
//
//        output.alertSettingOptInEditedResult
//            .withUnretained(self)
//            .sink { owner, isAllowed in
//                owner.alertListItem.configureSwitch(to: isAllowed)
//            }.store(in: self.cancelBag)
//
//        output.resetSuccessed
//            .filter { $0 }
//            .withUnretained(self)
//            .sink { owenr, _ in
//                owenr.showToast(message: I18N.MyPage.resetSuccess)
//            }.store(in: self.cancelBag)
//
//        output.deregisterPushTokenSuccess
//            .withUnretained(self)
//            .sink { owner, success in
//                owner.logout()
//                owner.onShowLogin?()
//            }.store(in: self.cancelBag)
//    }
//}
//
//extension AppMyPageVC {
//    private func logout() {
//        UserDefaultKeyList.Auth.appAccessToken = nil
//        UserDefaultKeyList.Auth.appRefreshToken = nil
//        UserDefaultKeyList.Auth.playgroundToken = nil
//        SFSafariViewController.DataStore.default.clearWebsiteData()
//    }
//}

// MARK: - UIGestureRecognizerDelegate

extension AppMyPageVC: UIGestureRecognizerDelegate {
    private func setGestureDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
