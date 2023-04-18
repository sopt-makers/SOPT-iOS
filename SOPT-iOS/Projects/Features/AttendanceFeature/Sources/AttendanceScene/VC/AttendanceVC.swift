//
//  AttendanceVC.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import AttendanceFeatureInterface

public class AttendanceVC: UIViewController, AttendanceViewControllable {
    private enum Metric {
        static let baseInset = 20.f
        static let contentInset = 16.f
        static let baseSpacing = 16.f
        
        static let closeButtonSize = 30.f
        static let bottomButtonHeight = 48.f
        
        static let customSpacing = 32.f
        static let keyboardBottomOffset = 40.f
    }
    
    // MARK: - Properties
    
    public var viewModel: AttendanceViewModel
    private var cancelBag = CancelBag()
    public var factory: AttendanceFeatureViewBuildable
    
    // MARK: - UI Components
    
    /// 출석하기 모달 뷰
    private let attendanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Metric.baseSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: Metric.contentInset, left: 0, bottom: Metric.contentInset, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    /// 상단 닫기 버튼
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.addArrangedSubviews(
            spacer,
            closeButton
        )
        return stackView
    }()
    
    private let spacer: UILabel = .init()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = DSKitAsset.Assets.opClose.image
        button.configuration = config
        return button
    }()
    
    /// 출석 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        #warning("서버 붙인 후 text 변경")
        label.text = "1차 출석하기"
        label.textColor = DSKitAsset.Colors.white100.color
        label.setTypoStyle(.Attendance.h1)
        return label
    }()
    
    /// 출석 코드 입력 설명
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.Attendance.inputCodeDescription
        label.textColor = DSKitAsset.Colors.gray60.color
        label.setTypoStyle(.Main.caption1)
        return label
    }()
    
    /// 출석 코드 입력 칸
    private lazy var attattendanceCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Metric.baseSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubviews(
            attendanceCodeView,
            alertLabel
        )
        return stackView
    }()
    
    private let attendanceCodeView: AttendanceCodeView = .init()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.Attendance.codeMismatch
        label.textColor = DSKitAsset.Colors.red100.color
        label.setTypoStyle(.Main.body2)
        label.isHidden = true
        return label
    }()
    
    /// 출석하기 버튼
    private let attendanceButton: OPCustomButton = {
        let button = OPCustomButton()
        button.setTitle(I18N.Attendance.takeAttendance, for: .normal)
        button.titleLabel!.setTypoStyle(.Attendance.h2)
        return button
    }()

    
    // MARK: - Init
    
    public init(viewModel: AttendanceViewModel, factory: AttendanceFeatureViewBuildable) {
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
        
        self.setUI()
        self.setLayout()
        self.bindViewModels()
        self.setObserver()
    }
}

// MARK: - UI & Layouts

extension AttendanceVC {
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.85)
        attendanceStackView.backgroundColor = DSKitAsset.Colors.black60.color
        attendanceStackView.layer.cornerRadius = 10
        attendanceCodeView.codeTextFields.first?.becomeFirstResponder()
    }
    
    private func setLayout() {
        attendanceStackView.addArrangedSubviews(
            topStackView,
            titleLabel,
            subtitleLabel,
            attattendanceCodeStackView,
            attendanceButton
        )
    
        view.addSubviews(attendanceStackView)
        
        topStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.contentInset)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.equalTo(Metric.closeButtonSize)
            $0.width.equalTo(Metric.closeButtonSize)
        }
        
        attendanceStackView.setCustomSpacing(32, after: attattendanceCodeStackView)
        
        attendanceButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.contentInset)
            $0.height.equalTo(Metric.bottomButtonHeight)
        }
        
        attendanceStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.baseInset)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension AttendanceVC {
    
    private func bindViewModels() {
        
        let input = AttendanceViewModel.Input()
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
    }
}
