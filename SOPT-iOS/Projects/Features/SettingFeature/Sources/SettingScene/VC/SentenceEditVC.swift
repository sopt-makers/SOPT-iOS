//
//  SentenceEditVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import BaseFeatureDependency
import SettingFeatureInterface
import StampFeatureInterface

public class SentenceEditVC: UIViewController, SentenceEditViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: SentenceEditViewModel!
    public var factory: (StampFeatureViewBuildable & AlertViewBuildable)!
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Setting.SentenceEdit.sentenceEdit)
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = DSKitAsset.Colors.black80.color
        tv.textColor = DSKitAsset.Colors.white.color
        tv.setTypoStyle(DSKitFontFamily.Suit.medium.font(size: 16))
        tv.layer.cornerRadius = 9.adjustedH
        tv.layer.borderWidth = 1.adjustedH
        tv.layer.borderColor = DSKitAsset.Colors.purple100.color.cgColor
        tv.isEditable = true
        tv.textContainerInset = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
        tv.delegate = self
        return tv
    }()
    
    private let saveButton = AppCustomButton(title: I18N.Setting.SentenceEdit.save)
        .setEnabled(false)
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension SentenceEditVC {
    
    private func bindViewModels() {
        let textViewTextChanged = NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self.textView)
            .dropFirst()
            .map { ($0.object as? UITextView)?.text }
            .compactMap { $0 }
            .eraseToAnyPublisher()
            .asDriver()
        
        let saveButtonTapped = self.saveButton
            .publisher(for: .touchUpInside)
            .compactMap { _ in self.textView.text }
            .filter { !$0.isEmpty }
            .asDriver()
        
        let input = SentenceEditViewModel.Input(textChanged: textViewTextChanged,
                                                saveButtonTapped: saveButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$saveButtonEnabled
            .assign(to: self.saveButton.kf.isEnabled, on: self.saveButton)
            .store(in: self.cancelBag)
        
        output.$defaultText
            .assign(to: self.textView.kf.text, on: self.textView)
            .store(in: self.cancelBag)
        
        output.editSuccessed
            .withUnretained(self)
            .sink { owner, isSuccessed in
                if isSuccessed {
                    owner.showToastAndPopView()
                } else {
                    owner.showNetworkAlert()
                }
            }.store(in: self.cancelBag)
    }
    
    private func showToastAndPopView() {
        self.navigationController?.popViewController(animated: true)
        let window = self.view.window!
        Toast.show(message: I18N.Setting.SentenceEdit.sentenceEditSuccess,
                   view: window,
                   safeAreaBottomInset: self.safeAreaBottomInset())
    }
    
    public func showNetworkAlert() {
        let alertVC = factory.makeNetworkAlertVC(theme: .soptamp).viewController
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
}

// MARK: - UI & Layout

extension SentenceEditVC {
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, textView, saveButton)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(8.adjustedH)
            make.leading.trailing.equalToSuperview().inset(20.adjusted)
            make.height.equalTo(64.adjustedH)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(32.adjustedH)
            make.leading.trailing.equalToSuperview().inset(20.adjusted)
            make.height.equalTo(56.adjustedH)
        }
    }
}

// MARK: - TextViewDelegate

extension SentenceEditVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 42
    }
}
