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

import Domain

import Combine
import SnapKit
import Then

import AuthFeatureInterface
import StampFeatureInterface

public class SignInVC: UIViewController, SignInViewControllable {
    
    // MARK: - Properties
    
    public var factory: (AuthFeatureViewBuildable & StampFeatureViewBuildable)!
    public var viewModel: SignInViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.logo.image
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private lazy var emailTextField = CustomTextFieldView(type: .subTitle)
        .setTextFieldType(.email)
        .setSubTitle(I18N.SignIn.id)
        .setPlaceholder(I18N.SignIn.enterID)
        .setAlertDelegate(passwordTextField)

    private lazy var passwordTextField = CustomTextFieldView(type: .subTitle)
        .setTextFieldType(.password)
        .setSubTitle(I18N.SignIn.password)
        .setPlaceholder(I18N.SignIn.enterPW)
        .setAlertLabelEnabled(I18N.SignIn.checkAccount)
    
    private lazy var findAccountButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.findAccount, for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.gray500.color, for: .normal)
        $0.titleLabel!.setTypoStyle(.SoptampFont.caption2)
        $0.addTarget(self, action: #selector(findAccountButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var signInButton = CustomButton(title: I18N.SignIn.signIn).setEnabled(false)
    
    private lazy var signUpButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.signUp, for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.gray900.color, for: .normal)
        $0.titleLabel!.setTypoStyle(.SoptampFont.caption1)
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @objc Function
    
    @objc
    private func findAccountButtonDidTap() {
        let findAccountVC = self.factory.makeFindAccountVC().viewController
        self.navigationController?.pushViewController(findAccountVC, animated: true)
    }
    
    @objc
    private func signUpButtonDidTap() {
        let signUpVC = self.factory.makeSignUpVC().viewController
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
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(logoImageView, emailTextField, passwordTextField,
                                  findAccountButton, signInButton, signUpButton)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        containerView.snp.makeConstraints { make in
            let bottomInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom
            let topInset = abs(calculateTopInset())
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(UIScreen.main.bounds.height
                                - bottomInset
                                - topInset
                                + 1)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7.adjusted)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(95.adjustedH)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12.adjustedH)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(-20.adjustedH)
            make.trailing.equalToSuperview().inset(22)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(findAccountButton.snp.bottom).offset(48.adjustedH)
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
        
        let signInButtonTapped = signInButton
            .publisher(for: .touchUpInside)
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.showLoading()
            })
            .map { _ in
            SignInRequest(email: self.emailTextField.text, password: self.passwordTextField.text) }
            .asDriver()
        
        let input = SignInViewModel.Input(emailTextChanged: emailTextField.textChanged,
                                          passwordTextChanged: passwordTextField.textChanged,
                                          signInButtonTapped: signInButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.isFilledForm.assign(to: \.isEnabled, on: self.signInButton).store(in: self.cancelBag)
        
        output.isSignInSuccess.sink { [weak self] isSignInSuccess in
            guard let self = self else { return }
            self.stopLoading()
            if isSignInSuccess {
                let navigation = UINavigationController(rootViewController: self.factory.makeMissionListVC(sceneType: .default).viewController)
                ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true)
            } else {
                self.emailTextField.alertType = .invalidInput(text: "")
                self.passwordTextField.alertType = .invalidInput(text: I18N.SignIn.checkAccount)
            }
        }.store(in: self.cancelBag)
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
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.1,
                animations: {
                    let contentInset = UIEdgeInsets(
                        top: 0.0,
                        left: 0.0,
                        bottom: keyboardRectangle.size.height,
                        right: 0.0)
                    self.scrollView.contentInset = contentInset
                    self.scrollView.scrollIndicatorInsets = contentInset
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        let contentInset = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
}
