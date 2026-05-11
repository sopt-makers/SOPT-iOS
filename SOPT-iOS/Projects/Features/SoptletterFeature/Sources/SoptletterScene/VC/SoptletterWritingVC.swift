//
//  SoptletterWritingVC.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

import SnapKit
import Then

import BaseFeatureDependency

public final class SoptletterWritingVC: UIViewController, SoptletterViewControllable {

    // MARK: - Properties

    public let viewModel: SoptletterWritingViewModel
    private let cancelBag = CancelBag()

    private lazy var naviBackTap: Driver<Void> = naviBar.backButtonTapped

    // MARK: - UI Components

    private lazy var naviBar = OPNavigationBar(self, type: .bothButtons)
        .addMiddleLabel(title: I18N.Soptletter.navigationTitle)

    // MARK: - Init

    public init(viewModel: SoptletterWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        bindViewModels()
    }
}

// MARK: - UI & Layout

private extension SoptletterWritingVC {
    func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        navigationController?.navigationBar.isHidden = true
    }

    func setLayout() {
        view.addSubview(naviBar)

        naviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

    func bindViewModels() {
        let input = SoptletterWritingViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackTap: naviBackTap
        )

        let _ = self.viewModel.transform(from: input, cancelBag: cancelBag)
    }
}
