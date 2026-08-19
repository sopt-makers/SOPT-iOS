//
//  AlertVC.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import SnapKit

import MDS

public final class AlertVC: UIViewController, AlertViewControllable {

    // MARK: - Properties

    public var customAction: (() -> Void)?
    public var cancelAction: (() -> Void)?
    public var isCheckBoxSelected: Bool { dialog.isCheckBoxSelected }

    private let type: AlertType
    private let titleText: String
    private let descriptionText: String?
    private let checkBoxTitle: String?

    // MARK: - UI Components

    private let dimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Bg.Dim.default
        return view
    }()

    private lazy var dialog = MDSDialog(
        variant: type.mdsVariant,
        title: titleText,
        description: descriptionText,
        checkBoxTitle: checkBoxTitle
    )

    // MARK: - Init

    public init(type: AlertType, title: String, description: String? = nil, checkBoxTitle: String? = nil) {
        self.type = type
        self.titleText = title
        self.descriptionText = description
        self.checkBoxTitle = checkBoxTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycles

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }

    // MARK: - @objc

    @objc
    private func dismissCurrentVC() {
        self.dismiss(animated: true) {
            self.cancelAction?()
        }
    }
}

// MARK: - UI & Layout

extension AlertVC {
    private func setUI() {
        self.view.backgroundColor = .clear

        dialog.onPrimaryTap = { [weak self] in
            self?.dismiss(animated: true) {
                self?.customAction?()
            }
        }
        dialog.onSecondaryTap = { [weak self] in
            self?.dismiss(animated: true) {
                self?.cancelAction?()
            }
        }
    }

    private func setLayout() {
        self.view.addSubviews(dimmerView, dialog)

        dimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        dialog.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setAddTarget() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissCurrentVC))
        self.dimmerView.addGestureRecognizer(gesture)
    }
}
