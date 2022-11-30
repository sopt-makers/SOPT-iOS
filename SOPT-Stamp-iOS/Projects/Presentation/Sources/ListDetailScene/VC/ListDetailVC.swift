//
//  ListDetailVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import PhotosUI
import SnapKit
import Then

import Core
import DSKit

public enum listDetailType {
    case none // 작성 전
    case completed // 작성 완료
    case edit // 수정
}

public enum textViewState {
    case inactive // 비활성화(키보드X, placeholder)
    case active // 활성화(키보드O, 텍스트 입력 상태)
    case completed // 작성 완료
}

public class ListDetailVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: ListDetailViewModel!
    public var factory: ModuleFactoryInterface!
    private var cancelBag = CancelBag()
    public var viewType: listDetailType! = listDetailType.none
    private let picker = UIImagePickerController()
  
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.ListDetail.mission)
        .setRightButton(.none)
    private let contentStackView = UIStackView()
    
    private let missionView = UIView()
    private let starStackView = UIStackView()
    private let firstStarImageView = UIImageView()
    private let secondStarImageView = UIImageView()
    private let thirdStarImageView = UIImageView()
    private let missionLabel = UILabel()
    
    private let missionImageView = UIImageView()
    private let imagePlaceholderLabel = UILabel()
    private let textView = UITextView()
    private let dateLabel = UILabel()
    private let bottomButton = CustomButton(title: I18N.ListDetail.missionComplete).setEnabled(false)
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setLayout()
        self.setStackView()
        self.setDefaultUI()
        self.setUI(viewType)
        self.setAddTarget()
        self.setDelegate()
    }
}

// MARK: - Methods

extension ListDetailVC {
    private func bindViewModels() {
        let input = ListDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func setAddTarget() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLibrary))
        missionImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setDelegate() {
        self.textView.delegate = self
    }
    
    // MARK: - @objc
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                [self.contentStackView, self.bottomButton, self.imagePlaceholderLabel].forEach {
                    $0.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 40)
                }
            })
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        [self.contentStackView, self.bottomButton, self.imagePlaceholderLabel].forEach {
            $0.transform = .identity }
    }
    
    @objc
    private func openLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ListDetailVC: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        self.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self.missionImageView.image = selectedImage
                    self.imagePlaceholderLabel.isHidden = true
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ListDetailVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == I18N.ListDetail.memoPlaceHolder {
            self.textView.text = .none
            setTextView(.active)
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            self.textView.text = I18N.ListDetail.memoPlaceHolder
            setTextView(.inactive)
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.bottomButton.setEnabled(textView.hasText)
    }
}

// MARK: - UI & Layout

extension ListDetailVC {
    private func setDefaultUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .white
        self.setStatusBarBackgroundColor(.white)
        self.missionImageView.backgroundColor = DSKitAsset.Colors.gray50.color
        self.missionImageView.layer.masksToBounds = true
        self.missionImageView.contentMode = .scaleAspectFill
        
        self.missionView.layer.cornerRadius = 9
        self.missionImageView.layer.cornerRadius = 9
        self.textView.layer.cornerRadius = 12
        self.textView.layer.borderColor = DSKitAsset.Colors.purple300.color.cgColor
        self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        self.missionLabel.textColor = DSKitAsset.Colors.gray900.color
        self.imagePlaceholderLabel.textColor = DSKitAsset.Colors.gray500.color
        self.dateLabel.textColor = DSKitAsset.Colors.gray600.color
        
        self.missionLabel.setTypoStyle(.subtitle1)
        self.imagePlaceholderLabel.setTypoStyle(.subtitle2)
        self.textView.setTypoStyle(.caption1)
        self.dateLabel.setTypoStyle(.number3)
        
        [self.firstStarImageView, self.secondStarImageView, self.thirdStarImageView].forEach { $0.backgroundColor = DSKitAsset.Colors.purple300.color }
        
        self.missionLabel.text = "앱잼 팀원 다 함께 바다 보고 오기"
        self.imagePlaceholderLabel.text = I18N.ListDetail.imagePlaceHolder
        self.textView.text = I18N.ListDetail.memoPlaceHolder
        self.dateLabel.text = "2022.10.25"
        
        self.textView.returnKeyType = .done
    }
    
    private func setUI(_ type: listDetailType) {
        if type == .edit {
            self.naviBar.setRightButton(.delete)
        }
        
        switch type {
        case .none, .edit:
            self.missionView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.setTextView(.inactive)
            self.imagePlaceholderLabel.isHidden = missionImageView.image == nil ? false : true
            self.bottomButton.isHidden = false
            self.dateLabel.isHidden = true
            self.missionImageView.isUserInteractionEnabled = true
        case .completed:
            self.naviBar.setRightButton(.addRecord)
            self.missionView.backgroundColor = DSKitAsset.Colors.purple100.color
            self.setTextView(.completed)
            self.imagePlaceholderLabel.isHidden = true
            self.bottomButton.isHidden = true
            self.dateLabel.isHidden = false
            self.missionImageView.isUserInteractionEnabled = false
        }
    }
    
    private func setTextView(_ state: textViewState) {
        switch state {
        case .inactive:
            self.textView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.textView.textColor = DSKitAsset.Colors.gray600.color
            self.textView.layer.borderWidth = .zero
            self.textView.isEditable = true
        case .active:
            self.textView.backgroundColor = DSKitAsset.Colors.white.color
            self.textView.textColor = DSKitAsset.Colors.gray900.color
            self.textView.layer.borderWidth = 1
            self.textView.isEditable = true
        case .completed:
            self.textView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.textView.textColor = DSKitAsset.Colors.gray900.color
            self.textView.layer.borderWidth = .zero
            self.textView.isEditable = false
        }
    }
    
    private func setStackView() {
        self.contentStackView.axis = .vertical
        self.contentStackView.distribution = .fill
        self.contentStackView.spacing = 16
        
        self.starStackView.axis = .horizontal
        self.starStackView.distribution = .fillEqually
        self.starStackView.spacing = 10
    }
    private func setLayout() {
        self.view.addSubviews([contentStackView, dateLabel,
                               imagePlaceholderLabel, bottomButton, naviBar])
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(naviBar.snp.bottom).offset(7)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(22)
            make.top.equalTo(contentStackView.snp.bottom).offset(12)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(56)
        }
        
        contentStackView.addArrangedSubviews([missionView, missionImageView, textView])
        
        missionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        missionImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.missionImageView.snp.width).multipliedBy(1.0)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.contentStackView.snp.width).multipliedBy(0.39)
        }
        
        imagePlaceholderLabel.snp.makeConstraints { make in
            make.center.equalTo(missionImageView.snp.center)
        }
        
        missionView.addSubviews([starStackView, missionLabel])
        
        starStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
        }
        
        missionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(starStackView.snp.bottom).offset(8)
        }
        
        starStackView.addArrangedSubviews([firstStarImageView, secondStarImageView, thirdStarImageView])
        
        firstStarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }
        
        secondStarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }
        
        thirdStarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }
    }
}
