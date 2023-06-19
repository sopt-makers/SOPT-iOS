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

import Combine
import SnapKit
import Then

import BaseFeatureDependency
import NotificationFeatureInterface

public final class NotificationDetailVC: UIViewController, NotificationDetailViewControllable {
    
    public typealias factoryType = AlertViewBuildable
    
    // MARK: - Properties
    
    public var viewModel: NotificationDetailViewModel
    public var factory: factoryType
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
        view.backgroundColor = DSKitAsset.Colors.black80.color
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Attendance.h1
        label.textColor = DSKitAsset.Colors.gray10.color
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.black40.color
        return view
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .Main.body1
        textView.textColor = DSKitAsset.Colors.gray20.color
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let shortCutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DSKitAsset.Colors.purple100.color
        config.image = DSKitAsset.Assets.btnArrowRight.image.withTintColor(DSKitAsset.Colors.gray10.color)
        config.background.cornerRadius = 10
        config.imagePlacement = .trailing
        config.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = UIFont.Attendance.h1
        attributeContainer.foregroundColor = DSKitAsset.Colors.gray10.color
        
        config.attributedTitle = AttributedString(I18N.Notification.shortcut, attributes: attributeContainer)
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: - initialization
    
    public init(viewModel: NotificationDetailViewModel, factory: factoryType) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.bindViews()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - UI & Layout

extension NotificationDetailVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.black100.color
        
        // 임시 텍스트
        titleLabel.text = "[GO SOPT] 32기 전체 회계 공지"
        textView.text = I18N.ServiceUsagePolicy.termsOfService
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
        let input = NotificationDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func bindViews() {
        self.shortCutButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                print("바로가기 버튼 터치: \(owner)")
            }.store(in: cancelBag)
    }
}
