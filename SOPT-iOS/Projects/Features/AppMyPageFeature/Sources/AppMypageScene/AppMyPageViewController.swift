//
//  AppMyPageViewController.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit
import Then

import Core
import DSKit
import BaseFeatureDependency
import SettingFeatureInterface
import AppMyPageFeatureInterface

public final class AppMyPageViewController: UIViewController, AppMyPageViewControllerable {
    // MARK: - Metric
    private enum Metric {
        static let navigationbarHeight = 44.f
        static let firstSectionGroupTop = 13.f
        static let sectionGroupLeadingTrailing = 20.f
        
        static let sectionGroupSpacing = 16.f
    }
    
    // MARK: - Local Variables
    private let viewModel: AppMyPageViewModel
    private let factory: SettingFeatureViewBuildable & AlertViewBuildable

    // MARK: Combine
    private let resetButtonTapped = PassthroughSubject<Bool, Never>()

    // MARK: - Views
    private lazy var navigationBar = AppNavigationBar(
        title: I18N.MyPage.navigationTitle,
        frame: self.view.frame
    )
    
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
    
    public init(
        viewModel: AppMyPageViewModel,
        factory: SettingFeatureViewBuildable & AlertViewBuildable
    ) {
        self.viewModel = viewModel
        self.factory = factory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppMyPageViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        self.setupLayouts()
        self.setupConstraints()
        self.addTabGestureOnListItems()
    }
}

extension AppMyPageViewController {
    private func setupLayouts() {
        self.view.addSubviews(self.navigationBar, self.scrollView)
        self.scrollView.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubviews(
            self.servicePolicySectionGroup,
            self.soptampSectionGroup,
            self.etcSectionGroup
        )
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
            $0.width.equalToSuperview()
            $0.top.equalToSuperview().inset(Metric.firstSectionGroupTop)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // TODO: - (@승호): 적절히 객체에 위임하기
    private func addTabGestureOnListItems() {
        self.navigationBar.leftChevronButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }

        self.servicePolicySectionGroup.addTapGestureRecognizer {
            let viewController = self.factory.makePrivacyPolicyVC().viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        self.termsOfUseListItem.addTapGestureRecognizer {
            let viewController = self.factory.makeTermsOfServiceVC().viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        self.sendFeedbackListItem.addTapGestureRecognizer {
            openExternalLink(urlStr: ExternalURL.GoogleForms.serviceProposal)
        }
        
        self.editOnelineSentenceListItem.addTapGestureRecognizer {
            let viewController = self.factory.makeSentenceEditVC().viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        self.editNickNameListItem.addTapGestureRecognizer {
            let viewController = self.factory.makeNicknameEditVC().viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        self.resetStampListItem.addTapGestureRecognizer {
            let alertVC = self.factory.makeAlertVC(
                type: .titleDescription,
                theme: .main,
                title: I18N.Setting.resetMissionTitle,
                description: I18N.Setting.resetMissionDescription,
                customButtonTitle: I18N.Setting.reset
            ) { [weak self] in
                self?.resetButtonTapped.send(true)
            }.viewController
            
            self.present(alertVC, animated: true)
        }
        
        self.logoutListItem.addTapGestureRecognizer {

        }
        
        self.withDrawalListItem.addTapGestureRecognizer {
            // 다 머가 있더라. 다 대체해주자.
            // loginViewController로 내리면 됨니다?
        }
    }
}
