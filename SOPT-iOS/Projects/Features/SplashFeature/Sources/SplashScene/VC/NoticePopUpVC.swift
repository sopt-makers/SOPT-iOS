//
//  NoticePopUpVC.swift
//  Presentation
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import MDS

import SnapKit

import BaseFeatureDependency
import SplashFeatureInterface

public class NoticePopUpVC: UIViewController, LegacyNoticePopUpViewControllable, NoticePopUpViewControllable {

    // MARK: - Properties

    public var closeButtonTappedWithCheck = PassthroughSubject<Bool, Never>()

    private var type: NoticePopUpType?
    private var model: AppNoticeModel?

    // MARK: - UI Components

    private let dimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Bg.Dim.default
        return view
    }()

    private var dialog: MDSDialog?

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension NoticePopUpVC {

    public func setData(type: NoticePopUpType, model: AppNoticeModel) {
        self.type = type
        self.model = model
    }

    private func openAppStore() {
        if let url = URL(string: ExternalURL.AppStore.appStoreLink) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - UI & Layout

extension NoticePopUpVC {
    private func setUI() {
        view.backgroundColor = .clear

        guard let type, let model else { return }

        let alertType: AlertType
        let checkBoxTitle: String?
        switch type {
        case .forceUpdate:
            alertType = .information(primary: .init(I18N.Notice.goToUpdate))
            checkBoxTitle = nil
        case .recommendUpdate:
            alertType = .default(primary: .init(I18N.Notice.goToUpdate), secondary: .init(I18N.Notice.close))
            checkBoxTitle = I18N.Notice.didCheck
        }

        let dialog = MDSDialog(
            variant: alertType.mdsVariant,
            title: model.title,
            description: model.notice,
            checkBoxTitle: checkBoxTitle
        )
        dialog.onPrimaryTap = { [weak self] in
            self?.openAppStore()
        }
        dialog.onSecondaryTap = { [weak self, weak dialog] in
            guard let self, let dialog else { return }
            self.closeButtonTappedWithCheck.send(dialog.isCheckBoxSelected)
        }
        self.dialog = dialog
    }

    private func setLayout() {
        guard let dialog else { return }

        view.addSubviews(dimmerView, dialog)

        dimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        dialog.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
