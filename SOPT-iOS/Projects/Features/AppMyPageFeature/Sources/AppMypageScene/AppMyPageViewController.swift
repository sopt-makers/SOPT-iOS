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
    
    // MARK: - Local Variables
    private let viewModel: AppMyPageViewModel
    private let userType: UserType
    
    // MARK: - MyPageCoordinatable
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onPolicyItemTap: (() -> Void)?
    public var onTermsOfUseItemTap: (() -> Void)?
    public var onEditOnelineSentenceItemTap: (() -> Void)?
    public var onEditNicknameItemTap: (() -> Void)?
    public var onWithdrawalItemTap: ((UserType) -> Void)?
    public var onLoginItemTap: (() -> Void)?
    public var onShowLogin: (() -> Void)?
    public var onAlertSettingByFeaturesItemTap: (() -> Void)?
    
    // MARK: Combine
    private let viewWillAppear = PassthroughSubject<Void, Never>()
    private let resetButtonTapped = PassthroughSubject<Bool, Never>()
    private let alertSwitchTapped = PassthroughSubject<Bool, Never>()
    private let logoutButtonTapped = PassthroughSubject<Void, Never>()
    private let cancelBag = CancelBag()
    
    // MARK: - Views
    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: DSKitAsset.Colors.black100.color,
        ignoreLeftButtonAction: true
    )
        .addMiddleLabel(title: I18N.MyPage.navigationTitle)
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.sectionGroupSpacing
    }
    
    // MARK: ServicePolicy
    private lazy var servicePolicySectionGroup = MypageSectionGroupView(
        headerTitle: I18N.MyPage.servicePolicySectionTitle,
        subviews: [
            self.privacyPolicyListItem,
            self.termsOfUseListItem,
            self.sendFeedbackListItem
        ],
        frame: self.view.frame
    )
    
    private lazy var privacyPolicyListItem = MyPageSectionListItemView(
        title: I18N.MyPage.privacyPolicy,
        frame: self.view.frame
    )
    
    private lazy var termsOfUseListItem = MyPageSectionListItemView(
        title: I18N.MyPage.termsOfUse,
        frame: self.view.frame
    )
    
    private lazy var sendFeedbackListItem = MyPageSectionListItemView(
        title: I18N.MyPage.sendFeedback,
        frame: self.view.frame
    )
    
    // MARK: Alert
    private lazy var alertSectionGroup = MypageSectionGroupView(
        headerTitle: I18N.MyPage.alertSectionTitle,
        subviews: [
            self.alertListItem,
            self.alertByFeaturesListItem,
        ],
        frame: self.view.frame
    )
    
    private lazy var alertListItem = MyPageSectionListItemView(
        title: I18N.MyPage.alertListItemTitle,
        rightItemType: .switch(isOn: false),
        frame: self.view.frame
    )
    
    private lazy var alertByFeaturesListItem = MyPageSectionListItemView(
        title: I18N.MyPage.alertByFeaturesListItemTitle,
        frame: self.view.frame
    ).then {
        $0.isHidden = true
    }

    // MARK: Soptamp
    private lazy var soptampSectionGroup = MypageSectionGroupView(
        headerTitle: I18N.MyPage.soptampSectionTitle,
        subviews: [
            self.editOnelineSentenceListItem,
            self.editNickNameListItem,
            self.resetStampListItem
        ],
        frame: self.view.frame
    )
    
    private lazy var editOnelineSentenceListItem = MyPageSectionListItemView(
        title: I18N.MyPage.editOnlineSentence,
        frame: self.view.frame
    )
    
    private lazy var editNickNameListItem = MyPageSectionListItemView(
        title:  I18N.MyPage.editNickname,
        frame: self.view.frame
    )
    
    private lazy var resetStampListItem = MyPageSectionListItemView(
        title:  I18N.MyPage.resetStamp,
        frame: self.view.frame
    )
    
    // MARK: Etcs
    private lazy var etcSectionGroup = MypageSectionGroupView(
        headerTitle: I18N.MyPage.etcSectionGroupTitle,
        subviews: [
            self.logoutListItem,
            self.withDrawalListItem,
        ],
        frame: self.view.frame
    )
    
    private lazy var logoutListItem = MyPageSectionListItemView(
        title: I18N.MyPage.logout,
        frame: self.view.frame
    )
    
    private lazy var withDrawalListItem = MyPageSectionListItemView(
        title: I18N.MyPage.withdrawal,
        frame: self.view.frame
    )
    
    // MARK: For Visitors
    private lazy var etcForVisitorsSectionGroup = MypageSectionGroupView(
        headerTitle: I18N.MyPage.etcSectionGroupTitle,
        subviews: [
            self.loginListItem,
        ],
        frame: self.view.frame
    )
    
    private lazy var loginListItem = MyPageSectionListItemView(
        title: I18N.MyPage.login,
        frame: self.view.frame
    )
    
    public init(
        userType: UserType,
        viewModel: AppMyPageViewModel
    ) {
        self.userType = userType
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppMyPageVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        self.setupLayouts()
        self.setupConstraints()
        self.addTabGestureOnListItems()
        self.bindViews()
        self.bindViewModels()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppear.send(())
    }
}

extension AppMyPageVC {
    private func setupLayouts() {
        self.view.addSubviews(self.navigationBar, self.scrollView)
        self.scrollView.addSubview(self.contentStackView)
        
        switch self.userType {
        case .active, .inactive:
            self.contentStackView.addArrangedSubviews(
                self.servicePolicySectionGroup,
                self.alertSectionGroup,
                self.soptampSectionGroup,
                self.etcSectionGroup
            )
        case .visitor:
            self.contentStackView.addArrangedSubviews(
                self.servicePolicySectionGroup,
                self.etcForVisitorsSectionGroup
            )
        }
    }
    
    private func setupConstraints() {
        self.navigationBar.snp.makeConstraints {
            $0.height.equalTo(Metric.navigationbarHeight)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        self.contentStackView.snp.makeConstraints {
            $0.width.equalTo(self.view.frame.width - Metric.sectionGroupLeadingTrailing * 2)
            $0.top.equalToSuperview().inset(Metric.firstSectionGroupTop)
            $0.leading.trailing.equalToSuperview().inset(Metric.sectionGroupLeadingTrailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    // TODO: - (@승호): 적절히 객체에 위임하기
    private func addTabGestureOnListItems() {
        self.servicePolicySectionGroup.addTapGestureRecognizer {
            self.onPolicyItemTap?()
        }

        self.termsOfUseListItem.addTapGestureRecognizer {
            self.onTermsOfUseItemTap?()
        }

        self.sendFeedbackListItem.addTapGestureRecognizer {
            openExternalLink(urlStr: ExternalURL.GoogleForms.serviceProposal)
        }

        self.editOnelineSentenceListItem.addTapGestureRecognizer {
            self.onEditOnelineSentenceItemTap?()
        }

        self.editNickNameListItem.addTapGestureRecognizer {
            self.onEditNicknameItemTap?()
        }

        self.resetStampListItem.addTapGestureRecognizer {
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                theme: .main,
                title: I18N.MyPage.resetMissionTitle,
                description: I18N.MyPage.resetMissionDescription,
                customButtonTitle: I18N.MyPage.reset,
                customAction: { [weak self] in
                    self?.resetButtonTapped.send(true)
                },
                animated: true
            )
        }

        self.logoutListItem.addTapGestureRecognizer {
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                theme: .main,
                title: I18N.MyPage.logoutDialogTitle,
                description: I18N.MyPage.logoutDialogDescription,
                customButtonTitle: I18N.MyPage.logoutDialogGrantButtonTitle,
                customAction: { [weak self] in
                    self?.logoutButtonTapped.send()
                },
                animated: true
            )
        }

        self.withDrawalListItem.addTapGestureRecognizer {
            self.onWithdrawalItemTap?(self.userType)
        }
        
        self.loginListItem.addTapGestureRecognizer {
            self.onShowLogin?()
        }
        
        self.alertByFeaturesListItem.addTapGestureRecognizer {
            self.onAlertSettingByFeaturesItemTap?()
        }
    }
}

extension AppMyPageVC {
    private func bindViews() {
        self.alertListItem
            .signalForRightSwitchClick()
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] isOn in
                self?.alertSwitchTapped.send(isOn)
            }
            .store(in: self.cancelBag)
        
        self.navigationBar
            .leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: self.cancelBag)
    }
    
    private func bindViewModels() {
        let input = AppMyPageViewModel.Input(
            viewWillAppear: self.viewWillAppear.asDriver(),
            alertSwitchTapped: self.alertSwitchTapped.asDriver(),
            resetButtonTapped: self.resetButtonTapped.asDriver(),
            logoutButtonTapped: self.logoutButtonTapped.asDriver()
        )
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.originNotificationIsAllowed
            .sink { [weak self] isAllowed in
                self?.alertListItem.configureSwitch(to: isAllowed)
                self?.alertByFeaturesListItem.isHidden = !isAllowed
            }.store(in: self.cancelBag)
        
        output.alertSettingOptInEditedResult
            .sink { [weak self] isAllowed in
                self?.alertListItem.configureSwitch(to: isAllowed)
                self?.alertByFeaturesListItem.isHidden = !isAllowed
            }.store(in: self.cancelBag)
        
        output.resetSuccessed
            .filter { $0 }
            .sink { [weak self] _ in
                self?.showToast(message: I18N.MyPage.resetSuccess)
            }.store(in: self.cancelBag)
        
        output.deregisterPushTokenSuccess
            .sink { [weak self] success in
                self?.logout()
                self?.onShowLogin?()
            }.store(in: self.cancelBag)
    }
}

extension AppMyPageVC {
    private func logout() {
        UserDefaultKeyList.Auth.appAccessToken = nil
        UserDefaultKeyList.Auth.appRefreshToken = nil
        UserDefaultKeyList.Auth.playgroundToken = nil
        SFSafariViewController.DataStore.default.clearWebsiteData()
    }
}
