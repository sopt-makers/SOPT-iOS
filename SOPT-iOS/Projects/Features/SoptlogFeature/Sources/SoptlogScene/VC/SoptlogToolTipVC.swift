//
//  SoptlogToolTipVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 3/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit

import Core
import MDS

final class SoptlogToolTipVC: UIViewController, SoptlogToolTipViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: SoptlogToolTipViewModel
    private let cancelBag = CancelBag()
    private let toolTipFrame: CGRect
    private let arrowHeight: CGFloat = 12
    
    private var dimmingBackgroundTap = PassthroughSubject<Void, Never>()

    // MARK: - UI Components
    
    private let infoImageView = UIImageView().then {
        $0.image = MDSIcon.alertCircleOutlined.image
    }
    
    private let dismissButton = UIButton().then {
        $0.setImage(MDSIcon.xCloseOutlined.image, for: .normal)
    }
    
    private lazy var arrowView = UIView().then {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: self.arrowHeight, y: 0))
        path.addLine(to: CGPoint(x: self.arrowHeight / 2, y: self.arrowHeight))
        path.close()

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = SemanticColor.Bg.Neutral.default.cgColor
        $0.layer.addSublayer(shape)
    }
    
    private let toolTipView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.default
        $0.layer.cornerRadius = BaseRadius.Base.r12
    }
    
    private let toolTipTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let infoTitleLabel = UILabel().then {
        $0.text = I18N.Soptlog.toolTipTitle
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
    }
    
    private let infoContentsLabel = UILabel().then {
        $0.text = I18N.Soptlog.toolTip
        $0.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.bold)
        $0.numberOfLines = 0
    }
    
    init(viewModel: SoptlogToolTipViewModel, toolTipFrame: CGRect) {
        self.viewModel = viewModel
        self.toolTipFrame = toolTipFrame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModels()
    }
}

// MARK: - UI & Layout

extension SoptlogToolTipVC {
    private func setUI() {
        self.view.backgroundColor = SemanticColor.Bg.Layer.basement.withAlphaComponent(0.65)
    }
    
    private func setLayout() {
        setStackView()
        toolTipView.addSubviews(toolTipTitleStackView, infoContentsLabel)
        view.addSubviews(toolTipView, arrowView)
        
        arrowView.snp.makeConstraints { make in
            make.size.equalTo(arrowHeight)
            make.top.equalToSuperview().offset(toolTipFrame.minY - 7 - arrowHeight)
            make.centerX.equalTo(toolTipFrame.midX)
        }
        
        toolTipView.snp.makeConstraints { make in
            make.bottom.equalTo(arrowView.snp.top)
            make.leading.equalTo(toolTipFrame.minX - 26)
            make.width.equalTo(272)
            make.height.equalTo(94)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        
        toolTipTitleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        infoContentsLabel.snp.makeConstraints { make in
            make.top.equalTo(toolTipTitleStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setStackView() {
        toolTipTitleStackView.addArrangedSubviews(infoImageView, infoTitleLabel, dismissButton)
    }
}

// MARK: - Methods

extension SoptlogToolTipVC {
    private func bindViewModels() {
        let input = SoptlogToolTipViewModel.Input(
            dismissbuttonTap: self.dismissButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            dimmingBackgroundTap: self.dimmingBackgroundTap.asDriver()
        )
        
        _ = viewModel.transform(from: input, cancelBag: cancelBag)
    }
}

// MARK: - Override Methods

extension SoptlogToolTipVC {
    /// dimming 뒷배경을 눌렀을 때, dismiss 이벤트를 전달합니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        // toolTipView 프레임의 밖일 경우에만 dismiss
        if !toolTipView.frame.contains(location) {
            self.dimmingBackgroundTap.send()
        }
        super.touchesBegan(touches, with: event)
    }
}
