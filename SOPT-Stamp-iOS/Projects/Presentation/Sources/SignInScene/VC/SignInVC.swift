//
//  SignInVC.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import DSKit

import Core

import Combine
import SnapKit
import Then

public class SignInVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: SignInViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.logo.image
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private lazy var emailTextField = CustomTextFieldView(type: .subTitle)
        .setTextFieldType(.email)
        .setSubTitle(I18N.SignIn.id)
        .setPlaceholder(I18N.SignIn.enterID)

    private lazy var passwordTextField = CustomTextFieldView(type: .subTitle)
        .setTextFieldType(.password)
        .setSubTitle(I18N.SignIn.password)
        .setPlaceholder(I18N.SignIn.enterPW)
    
    private lazy var findAccountButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.findAccount, for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.gray500.color, for: .normal)
        $0.titleLabel!.setTypoStyle(.caption2)
        $0.addTarget(self, action: #selector(findAccountButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var signInButton = CustomButton(title: I18N.SignIn.signIn).setEnabled(false).then {
        $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var signUpButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.signUp, for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.gray900.color, for: .normal)
        $0.titleLabel!.setTypoStyle(.caption1)
        $0.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.setTapGesture()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }
    
    deinit {
        self.removeKeyboardObserver()
    }
    
    // MARK: - @objc Function
    
    @objc
    private func findAccountButtonDidTap() {
        print("find account btn did tap")
    }
    
    @objc
    private func signInButtonDidTap() {
        print("sign in btn did tap")
    }
    
    @objc
    private func signUpButtonDidTap() {
        let signUpVC = self.factory.makeSignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }

}

// MARK: - UI & Layout

extension SignInVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.white.color
        self.findAccountButton.setUnderline()
        self.signUpButton.setUnderline()
    }
    
    private func setLayout() {
        self.view.addSubviews(logoImageView, emailTextField, passwordTextField, findAccountButton, signInButton, signUpButton)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(90.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12.adjustedH)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(22)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(findAccountButton.snp.bottom).offset(55.adjustedH)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(15.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
}

// MARK: - Methods

extension SignInVC {
  
    private func bindViewModels() {
//        let input = SignInViewModel.Input()
//        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
//            let safeHeight = self.view.safeAreaInsets.bottom
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.view.transform =
                    CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height))
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
}
