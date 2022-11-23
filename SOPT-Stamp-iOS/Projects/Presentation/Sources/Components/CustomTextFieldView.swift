//
//  CustomTextFieldView.swift
//  PresentationTests
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Core
import DSKit

@frozen
enum TextFieldViewType {
    case plain
    case subTitle
    case titleWithRightButton
}

// 1. subLabel 넣는 함수
// 2. cornerRadius 주는 함수
// 3. textField placeholder 텍스트 입력 받는 함수
// 4. textField타입 설정하는 함수 (이메일, 비밀번호)

class CustomTextFieldView: UIView {
    
    // MARK: - Properties
    private typealias SoptampColor = DSKitAsset.Colors
    
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    // MARK: - UI Component
    
    private let titleLabel = UILabel()
    private let textFieldContainerView = UIView()
    private let subTitleLabel = UILabel()
    private let textField = UITextField()
    private let rightButton = UIButton()
    private let alertlabel = UILabel()

    // MARK: - Initialize
    
    init(type: TextFieldViewType) {
        super.init(frame: .zero)
        self.setUI(type)
        self.setLayout(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method

extension CustomTextFieldView {
    private func setUI(_ type: TextFieldViewType) {
        self.clipsToBounds = true
        
        titleLabel.font = UIFont.subtitle1
        titleLabel.textColor = SoptampColor.gray900.color
        
        textFieldContainerView.backgroundColor = SoptampColor.gray50.color

        subTitleLabel.textAlignment = .left
        subTitleLabel.font = UIFont.id
        subTitleLabel.textColor = SoptampColor.gray400.color
        
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = UIFont.caption1
        textField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [
                .foregroundColor: SoptampColor.gray600.color,
                .font: UIFont.caption1
            ]
        )
        
        alertlabel.font = UIFont.caption3
        alertlabel.textColor = SoptampColor.error300.color
        
        rightButton.setBackgroundColor(
            SoptampColor.purple200.color,
            for: .disabled
        )
        
        rightButton.setBackgroundColor(
            SoptampColor.purple300.color,
            for: .normal
        )
        
        rightButton.setAttributedTitle(
            NSAttributedString(string: I18N.TextFieldView.verify,
                               attributes: [.foregroundColor: SoptampColor.white.color, .font: UIFont.subtitle3]),
            for: .normal
        )
    }
    
    private func setLayout(_ type: TextFieldViewType) {
        self.addSubview(textFieldContainerView)
        switch type {
        case .plain:
            self.setPlainLayout()
        case .subTitle:
            self.setSubTitleLayout()
        case .titleWithRightButton:
            self.setTitleWithRightButtonLayout()
        }
    }
    
    private func setPlainLayout() {
        textFieldContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldContainerView.addSubviews(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setSubTitleLayout() {
        textFieldContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldContainerView.addSubviews(subTitleLabel, textField)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.leading.trailing.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(6)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setTitleWithRightButtonLayout() {
        self.addSubviews(titleLabel, rightButton)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.height.equalTo(48)
            make.trailing.equalTo(rightButton.snp.leading).inset(-4)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(textFieldContainerView)
            make.trailing.equalToSuperview()
            make.width.equalTo(60)
        }
        
        textFieldContainerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
