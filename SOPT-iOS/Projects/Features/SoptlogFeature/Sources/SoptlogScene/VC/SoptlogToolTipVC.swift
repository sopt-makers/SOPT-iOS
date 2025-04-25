//
//  SoptlogToolTipVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 3/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import SnapKit

final class SoptlogToolTipVC: UIViewController, SoptlogToolTipViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: SoptlogToolTipViewModel
    private let cancelBag = CancelBag()
    private let toolTipFrame: CGRect
    
    private var dimmingBackgroundTap = PassthroughSubject<Void, Never>()

    // MARK: - UI Components
    
    private let infoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icInfo.image.withTintColor(DSKitAsset.Colors.white100.color)
    }
    
    private let dismissButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icCloseWhite.image, for: .normal)
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.tooltipArrow.image
    }
    
    private let toolTipView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
        $0.layer.cornerRadius = 12
    }
    
    private let toolTipTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let infoTitleLabel = UILabel().then {
        $0.text = I18N.Soptlog.toolTipTitle
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let infoContentsLabel = UILabel().then {
        $0.text = I18N.Soptlog.toolTip
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.numberOfLines = 0
        $0.setLineSpacing(lineSpacing: 4)
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
        self.view.backgroundColor = DSKitAsset.Colors.black100.color.withAlphaComponent(0.6)
    }
    
    private func setLayout() {
        setStackView()
        toolTipView.addSubviews(toolTipTitleStackView, infoContentsLabel)
        view.addSubviews(toolTipView, arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(toolTipFrame.maxY + 5)
            make.centerX.equalTo(toolTipFrame.midX)
            make.size.equalTo(12)
        }
        
        toolTipView.snp.makeConstraints { make in
            make.top.equalTo(arrowImageView.snp.bottom)
            make.leading.equalToSuperview().inset(68)
            make.width.equalTo(263)
            make.height.equalTo(100)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        
        toolTipTitleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(20)
        }
        
        infoContentsLabel.snp.makeConstraints { make in
            make.top.equalTo(toolTipTitleStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(18)
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
