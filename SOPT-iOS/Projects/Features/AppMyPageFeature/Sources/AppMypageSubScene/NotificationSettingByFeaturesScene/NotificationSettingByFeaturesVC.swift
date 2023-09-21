//
//  NotificationSettingByFeaturesVC.swift
//  AppMyPageFeatureTests
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit
import Then

import Core
import DSKit

import BaseFeatureDependency

public final class NotificationSettingByFeaturesVC: UIViewController, NotificationSettingByFeaturesViewControllable {
    private enum Metric {
        static let navigationbarHeight = 44.f
        
        static let headerViewHeight = 15.f
        static let pageDescriptionTop = 13.f
        static let contentsTop = 24.f
        static let contentsLeadingTrailing = 20.f
        static let listItemPadding = 8.f
    }
    
    public var onNaviBackButtonTap: (() -> Void)?
    
    // MARK: - Views
    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: DSKitAsset.Colors.black100.color,
        ignoreLeftButtonAction: true
    )
        .addMiddleLabel(title: I18N.NotificationSettingsByFeature.navigationTitle)
    
    private let headerView = UIView()
    private let headerLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray80.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.text = I18N.NotificationSettingsByFeature.notificationSectionDescrition
    }
    
    private lazy var allNotificationListItem = NotificationSettingsListItemView(
        title: I18N.NotificationSettingsByFeature.allNotificationListItemTitle,
        frame: self.view.frame
    )
    
    private lazy var notificaitonByPartListItem = NotificationSettingsListItemView(
        title: I18N.NotificationSettingsByFeature.notificaitonByPartListItemTitle,
        frame: self.view.frame
    )
    
    private lazy var infoNotificationListItem = NotificationSettingsListItemView(
        title: I18N.NotificationSettingsByFeature.infoNotificationListItemTitle,
        frame: self.view.frame
    )
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.listItemPadding
    }
    
    // MARK: - Variables
    private let cancelBag = CancelBag()
    private let willAppearSubject = PassthroughSubject<Void, Never>()
    
    private let allOptInTapped = PassthroughSubject<Bool, Never>()
    private let partOptInTapped = PassthroughSubject<Bool, Never>()
    private let infoOptInTapped = PassthroughSubject<Bool, Never>()
    
    private let viewModel: NotificationSettingByFeaturesViewModel

    public init(viewModel: NotificationSettingByFeaturesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        self.setupLayouts()
        self.setupConstraints()
        
        self.bindViews()
        self.bindViewModels()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.willAppearSubject.send(())
    }
}

extension NotificationSettingByFeaturesVC {
    private func setupLayouts() {
        self.view.addSubviews(self.navigationBar, self.headerView, self.contentStackView)
        self.contentStackView.addArrangedSubviews(
            self.allNotificationListItem,
            self.notificaitonByPartListItem,
            self.infoNotificationListItem
        )
        self.headerView.addSubview(self.headerLabel)
    }
    
    private func setupConstraints() {
        self.navigationBar.snp.makeConstraints {
            $0.height.equalTo(Metric.navigationbarHeight)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom).offset(Metric.pageDescriptionTop)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.contentStackView.snp.makeConstraints {
            $0.top.equalTo(self.headerView.snp.bottom).offset(Metric.contentsTop)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        self.headerView.snp.makeConstraints { $0.height.equalTo(Metric.headerViewHeight) }
        self.headerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.contentsLeadingTrailing)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func bindViews() {
        self.navigationBar
            .leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: self.cancelBag)
        
        self.allNotificationListItem
            .signalForRightSwitchClick()
            .sink { [weak self] isOn in
                self?.allOptInTapped.send(isOn)
            }
            .store(in: self.cancelBag)
        
        self.notificaitonByPartListItem
            .signalForRightSwitchClick()
            .sink { [weak self] isOn in
                self?.partOptInTapped.send(isOn)
            }
            .store(in: self.cancelBag)

        self.infoNotificationListItem
            .signalForRightSwitchClick()
            .sink { [weak self] isOn in
                self?.infoOptInTapped.send(isOn)
            }
            .store(in: self.cancelBag)
    }
    
    private func bindViewModels() {
        let input = NotificationSettingByFeaturesViewModel.Input(
            viewWillAppear: self.willAppearSubject.asDriver(),
            allOptInTapped: self.allOptInTapped.asDriver(),
            partOptInTapped: self.partOptInTapped.asDriver(),
            infoOptInTapped: self.infoOptInTapped.asDriver()
        )
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output
            .firstFetchedNotificationModel
            .sink { [weak self] notifcationOptInModel in
                self?.allNotificationListItem.configureRightSwitch(to: notifcationOptInModel.allOptIn)
                self?.notificaitonByPartListItem.configureRightSwitch(to: notifcationOptInModel.partOptIn)
                self?.infoNotificationListItem.configureRightSwitch(to: notifcationOptInModel.newsOptIn)
            }.store(in: self.cancelBag)

        output
            .updateSuccessed
            .sink { [weak self] notifcationOptInModel in
                self?.allNotificationListItem.configureRightSwitch(to: notifcationOptInModel.allOptIn)
                self?.notificaitonByPartListItem.configureRightSwitch(to: notifcationOptInModel.partOptIn)
                self?.infoNotificationListItem.configureRightSwitch(to: notifcationOptInModel.newsOptIn)
            }.store(in: self.cancelBag)
    }
}
