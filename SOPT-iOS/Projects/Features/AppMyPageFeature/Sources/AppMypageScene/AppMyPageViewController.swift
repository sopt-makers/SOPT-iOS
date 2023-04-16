//
//  AppMyPageViewController.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import AppMyPageFeatureInterface

public final class AppMyPageViewController: UIViewController, AppMyPageViewControllerable {
    private enum Metric {
        static let firstSectionGroupTop = 13.f
        static let sectionGroupLeadingTrailing = 20.f
        
        static let sectionGroupSpacing = 16.f
    }
    
    
    private let viewModel: AppMyPageViewModel
//    private let factory  // factory
    
    // MARK: - Views
    private var navigationBar: AppMyPageNavigationBar?
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.sectionGroupSpacing
    }
    
    // MARK: ServicePolicy
    private lazy var servicePolicySectionGroup = MypageSectionGroupView(
        headerTitle: "서비스 이용 방침",
        subviews: [
            self.privacyPolicyListItem,
            self.termsOfUseListItem,
            self.sendFeedbackListItem
        ],
        frame: self.view.frame
    )
    
    private lazy var privacyPolicyListItem = MyPageSectionListItemView(
        title: "개인정보 처리 방침",
        frame: self.view.frame
    )
    
    private lazy var termsOfUseListItem = MyPageSectionListItemView(
        title: "서비스 이용 약관",
        frame: self.view.frame
    )
    
    private lazy var sendFeedbackListItem = MyPageSectionListItemView(
        title: "의견 보내기",
        frame: self.view.frame
    )
    
    // MARK: Soptamp
    private lazy var soptampSectionGroup = MypageSectionGroupView(
        headerTitle: "솝탬프 설정",
        subviews: [
            self.editOnelineSentenceListItem,
            self.editNickNameListItem,
            self.resetStampListItem
        ],
        frame: self.view.frame
    )
    
    private lazy var editOnelineSentenceListItem = MyPageSectionListItemView(
        title: "한 마디 편집",
        frame: self.view.frame
    )
    
    private lazy var editNickNameListItem = MyPageSectionListItemView(
        title: "닉네임 변경",
        frame: self.view.frame
    )
    
    private lazy var resetStampListItem = MyPageSectionListItemView(
        title: "스탬프 초기화",
        frame: self.view.frame
    )
    
    // MARK: Etcs
    private lazy var etcSectionGroup = MypageSectionGroupView(
        headerTitle: "기타",
        subviews: [
            self.logoutListItem,
            self.withDrawalListItem,
        ],
        frame: self.view.frame
    )
    
    private lazy var logoutListItem = MyPageSectionListItemView(
        title: "로그아웃",
        frame: self.view.frame
    )
    
    private lazy var withDrawalListItem = MyPageSectionListItemView(
        title: "탈퇴하기",
        frame: self.view.frame
    )
    
    public init(viewModel: AppMyPageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppMyPageViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        self.setupLayouts()
        self.setupConstraints()
        self.addTabGestureOnListItems()
    }
}

extension AppMyPageViewController {
    private func setupLayouts() {
        self.navigationBar = AppMyPageNavigationBar(frame: self.view.frame)
        self.navigationItem.titleView = self.navigationBar
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubviews(
            self.servicePolicySectionGroup,
            self.soptampSectionGroup,
            self.etcSectionGroup
        )
    }
    
    private func setupConstraints() {
        self.scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.contentStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview().inset(Metric.firstSectionGroupTop)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addTabGestureOnListItems() {
        self.navigationBar?.leftChevronButton.addTapGestureRecognizer {
            
        }

        self.servicePolicySectionGroup.addTapGestureRecognizer {

        }
        
        self.termsOfUseListItem.addTapGestureRecognizer {
            
        }
        
        self.termsOfUseListItem.addTapGestureRecognizer {
                
        }
        
        self.editOnelineSentenceListItem.addTapGestureRecognizer {
            
        }
        
        self.editNickNameListItem.addTapGestureRecognizer {
            
        }
        
        self.resetStampListItem.addTapGestureRecognizer {
            
        }
        
        self.logoutListItem.addTapGestureRecognizer {
            
        }
        
        self.withDrawalListItem.addTapGestureRecognizer {
            
        }
    }
}
