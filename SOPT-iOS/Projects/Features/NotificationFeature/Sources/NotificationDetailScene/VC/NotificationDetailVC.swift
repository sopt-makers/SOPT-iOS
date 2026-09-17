//
//  NotificationDetailVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

import Combine
import SnapKit
import Then

import Domain
import BaseFeatureDependency
import NotificationFeatureInterface

public final class NotificationDetailVC: UIViewController, NotificationDetailViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: NotificationDetailViewModel
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Notification.notification)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let scrollViewInset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 80, right: 0)
        scrollView.contentInset = scrollViewInset
        scrollView.scrollIndicatorInsets = scrollViewInset
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Bg.Neutral.ghost
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Stroke.Neutral.subtle
        return view
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let shortCutButton: MDSActionButton = {
        let button = MDSActionButton(
            variant: .primary,
            size: .large,
            title: I18N.Notification.shortcut
        )
        button.isHidden = true
        return button
    }()
    
    // MARK: - initialization
    
    public init(viewModel: NotificationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGestureDelegate()
    }
}

// MARK: - UI & Layout

extension NotificationDetailVC {
    private func setUI() {
        view.backgroundColor = SemanticColor.Bg.Layer.basement
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, scrollView, shortCutButton)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        setScrollViewLayout()
        
        shortCutButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
    }
    
    private func setScrollViewLayout() {
        self.scrollView.addSubviews(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubviews(titleLabel, dividerView, textView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}

// MARK: - Methods

extension NotificationDetailVC {
  
    private func bindViewModels() {
        let input = NotificationDetailViewModel.Input(
            viewDidLoad: Just(()).asDriver(),
            shortCutButtonTap: shortCutButton.publisher(for: .touchUpInside).mapVoid().asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.notification
            .withUnretained(self)
            .sink { owner, notification in
                owner.setData(with: notification)
            }.store(in: cancelBag)
    }
    
    private func setData(with notification: NotificationDetailModel) {
        self.titleLabel.text = notification.title
        self.titleLabel.setTypography(Typography.title4)
        
        self.textView.text = notification.content
        self.textView.setTypography(Typography.body1)
        
        self.shortCutButton.isHidden = !notification.hasLink
    }
}

// MARK: - UIGestureRecognizerDelegate

extension NotificationDetailVC: UIGestureRecognizerDelegate {
    private func setGestureDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
