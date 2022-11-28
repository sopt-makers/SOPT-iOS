//
//  SignUpVC.swift
//  Presentation
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit
import Then

import Core
import DSKit

public class SignUpVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: SignUpViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.SignUp.signUp)
        .setTitleTypoStyle(.h1)
    
    private let nickNameTextFieldView = CustomTextFieldView(type: .titleWithRightButton)
        .setTitle(I18N.SignUp.nickname)
        .setPlaceholder(I18N.SignUp.nicknameTextFieldPlaceholder)
        .setAlertLabelEnabled(I18N.SignUp.duplicatedNickname)
    
    private let emailTextFieldView = CustomTextFieldView(type: .titleWithRightButton)
        .setTitle(I18N.SignUp.email)
        .setPlaceholder(I18N.SignUp.emailTextFieldPlaceholder)
        .setTextFieldType(.email)
        .setAlertLabelEnabled(I18N.SignUp.invalidEmailForm)
    
    private let passwordTextFieldView = CustomTextFieldView(type: .title)
        .setTitle(I18N.SignUp.password)
        .setTextFieldType(.password)
        .setPlaceholder(I18N.SignUp.passwordTextFieldPlaceholder)
    
    private let passwordCheckTextFieldView = CustomTextFieldView(type: .plain)
        .setPlaceholder(I18N.SignUp.passwordCheckTextFieldPlaceholder)
        .setTextFieldType(.password)
        .setAlertLabelEnabled(I18N.SignUp.invalidPasswordForm)
    
    private let registerButton = CustomButton(title: I18N.SignUp.register)
        .setEnabled(false)

    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.setTapGesture()
        self.setKeyboardNotification()
    }
}

// MARK: - Methods

extension SignUpVC {
  
    private func bindViewModels() {
        let registerButtonTapped = registerButton
            .publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
        
        let input = SignUpViewModel.Input(
            nicknameCheckButtonTapped: nickNameTextFieldView.rightButtonTapped,
            emailCheckButtonTapped: emailTextFieldView.rightButtonTapped,
            passwordTextChanged: passwordTextFieldView.textChanged,
            passwordCheckTextChanged: passwordCheckTextFieldView.textChanged,
            registerButtonTapped: registerButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.nicknameAlert.sink { event in
            print("event: \(event)")
        } receiveValue: { [weak self] alertText in
            guard let self = self else { return }
            self.nickNameTextFieldView.changeAlertLabelText(alertText)
            if !alertText.isEmpty {
                self.nickNameTextFieldView.setTextFieldViewState(.alert)
            }
        }.store(in: cancelBag)
        
        output.emailAlert.sink { event in
            print("event: \(event)")
        } receiveValue: { [weak self] alertText in
            guard let self = self else { return }
            self.emailTextFieldView.changeAlertLabelText(alertText)
            if !alertText.isEmpty {
                self.emailTextFieldView.setTextFieldViewState(.alert)
            }
        }.store(in: cancelBag)
        
        output.passwordAlert.sink { event in
            print("event: \(event)")
        } receiveValue: { [weak self] alertText in
            guard let self = self else { return }
            self.passwordCheckTextFieldView.changeAlertLabelText(alertText)
            if !alertText.isEmpty {
                alertText == I18N.SignUp.invalidPasswordForm ?
                self.passwordTextFieldView.setTextFieldViewState(.alert) :
                self.passwordCheckTextFieldView.setTextFieldViewState(.alert)
            } else {
                self.passwordCheckTextFieldView.setTextFieldViewState(.editing)
            }
        }.store(in: cancelBag)
        
        output.isValidForm.sink { event in
            print("event: \(event)")
        } receiveValue: { [weak self] isValidForm in
            guard let self = self else { return }
            self.registerButton.setEnabled(isValidForm)
        }.store(in: cancelBag)
    }
}

// MARK: - UI & Layout

extension SignUpVC {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(
            naviBar,
            nickNameTextFieldView,
            emailTextFieldView,
            passwordTextFieldView,
            passwordCheckTextFieldView,
            registerButton
        )

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
        }
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        nickNameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(58)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextFieldView.snp.bottom).offset(46)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(46)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordCheckTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTextFieldView.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}

// MARK: - Methods

extension SignUpVC {
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }

        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}
