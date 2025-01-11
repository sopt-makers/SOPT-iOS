//
//  SignUpPhoneVerifyView.swift
//  AuthFeature
//
//  Created by 장석우 on 1/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core

final class SignUpPhoneVerifyView: UIView {
    
    public var viewModelInput: SignUpViewModel.Input.PhoneVerify {
        return .init(
            sendButtonTapped: sendButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            doneButtonTapped: doneButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            phoneTextFieldText: phoneTextField.publisher(for: .editingChanged).map { $0.text ?? "" }.asDriver(),
            codeTextFieldText: codeTextField.publisher(for: .editingChanged).map { $0.text ?? "" }.asDriver()
        )
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "SOPT 회원인증"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 24)
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "이곳은 SOPT 회원만을 위한 공간이에요.\nSOPT 회원인증을 위해 전화번호를 입력해 주세요."
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let phoneLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray80.color
    }
    
    private let phoneTextField = UITextField().then {
        $0.placeholder = "01012345678"
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.keyboardType = .numberPad
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.addLeftPadding(width: 20)
    }
    
    private let sendButton = AppImageTextButton(title: "전송하기").then {
        $0.titleLabel?.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let codeTextField = UITextField().then {
        $0.placeholder = "인증번호를 입력해주세요."
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.keyboardType = .numberPad
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.addLeftPadding(width: 20)
        $0.addRightPadding(width: 63)
    }
    
    private let timeLeftLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.white.color
        $0.text = "03:00"
    }
    
    private let failIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.alertCircle.image.withTintColor(DSKitAsset.Colors.error.color)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let failLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.error.color
        $0.isHidden = true
    }
    
    private let helpView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.blue400.color.withAlphaComponent(0.1)
        $0.layer.borderColor = DSKitAsset.Colors.blue400.color.withAlphaComponent(0.6).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let infoIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.infoCircle.image.withTintColor(
            DSKitAsset.Colors.blue500.color
        )
        $0.contentMode = .scaleAspectFit
    }
    
    private let helpTitleLabel = UILabel().then {
        $0.text = "SOPT 회원인증에 실패하셨나요?"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray30.color
    }
    
    private let chevronRightIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image.withTintColor(
            DSKitAsset.Colors.gray30.color
        )
        $0.contentMode = .scaleAspectFit
    }
    
    private let helpDescriptionLabel = UILabel().then {
        $0.text = "번호가 바뀌었거나, 인증이 어려우신 경우 추가 정보 인증을 통해 가입을 도와드리고 있어요!"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.numberOfLines = 0
    }
    
    private let doneButton = AppImageTextButton(title: "SOPT 회원 인증 완료").then {
        $0.configuration?.attributedTitle?.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUI() {
        self.addSubviews(
            titleLabel,
            descriptionLabel,
            phoneLabel,
            phoneTextField,
            sendButton,
            codeTextField,
            failIcon,
            failLabel,
            helpView,
            doneButton
        )
        
        codeTextField.addSubview(timeLeftLabel)
        
        helpView.addSubviews(
            infoIcon,
            helpTitleLabel,
            chevronRightIcon,
            helpDescriptionLabel
        )
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        sendButton.snp.makeConstraints {
            $0.centerY.equalTo(phoneTextField)
            $0.leading.equalTo(phoneTextField.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(110)
            $0.height.equalTo(phoneTextField)
        }
        
        codeTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(phoneTextField)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        timeLeftLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        failIcon.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(8)
            $0.leading.equalTo(codeTextField)
            $0.size.equalTo(14)
        }
        
        failLabel.snp.makeConstraints {
            $0.centerY.equalTo(failIcon)
            $0.leading.equalTo(failIcon.snp.trailing).offset(4)
            $0.trailing.equalTo(codeTextField)
        }
        
        helpView.snp.makeConstraints {
            $0.top.equalTo(failLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(codeTextField)
        }
        
        infoIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(18)
            $0.size.equalTo(20)
        }
        
        helpTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoIcon)
            $0.leading.equalTo(infoIcon.snp.trailing).offset(10)
        }
        
        chevronRightIcon.snp.makeConstraints {
            $0.centerY.equalTo(helpTitleLabel)
            $0.leading.equalTo(helpTitleLabel.snp.trailing)
            $0.size.equalTo(16)
        }
        
        helpDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(helpTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(helpTitleLabel)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }
}

extension SignUpPhoneVerifyView {
    
    func bindOutput(
        _ output: SignUpViewModel.Output.PhoneVerify,
        cancelBag: CancelBag) {
            
            output.isSent
                .map { $0 ? "재전송하기" : "전송하기" }
                .withUnretained(self)
                .sink { owner, text in
                    owner.sendButton.setTitle(text, for: .normal) 
                }
                .store(in: cancelBag)
            
            output.showToast
                .withUnretained(self)
                .sink { owner, text in
                    
                }
                .store(in: cancelBag)
            
            output.timerIsRunning
                .withUnretained(self)
                .sink { owner, isSent in
                    
                }
                .store(in: cancelBag)
            
            output.timeLeft
                .withUnretained(self)
                .sink { owner, time in
                    print(time)
                }
                .store(in: cancelBag)
            
            output.failDescription
                .withUnretained(self)
                .sink { owner, description in
                    owner.updateFailLabelUI(description)
                }
                .store(in: cancelBag)
            
            output.sendButtonIsEnabled
                .withUnretained(self)
                .sink { owner, isEnabled in
                    owner.sendButton.isEnabled = isEnabled
                }
                .store(in: cancelBag)
            
            output.doneButtonIsEnabled
                .withUnretained(self)
                .sink { owner, isEnabled in
                    owner.doneButton.isEnabled = isEnabled
                }
                .store(in: cancelBag)
            
            output.timeLeft
                .withUnretained(self)
                .sink { owner, timeLeft in
                    owner.timeLeftLabel.text = timeLeft.to_mmss
                }
                .store(in: cancelBag)
        }
    
    
    private func updateFailLabelUI(_ description: String?) {
        failLabel.text = description
        failIcon.isHidden = description == nil
        failLabel.isHidden = description == nil
        timeLeftLabel.textColor = description == nil ? DSKitAsset.Colors.white.color : DSKitAsset.Colors.error.color
        codeTextField.layer.borderColor = description == nil ? UIColor.clear.cgColor : DSKitAsset.Colors.error.color.cgColor
    }
}
