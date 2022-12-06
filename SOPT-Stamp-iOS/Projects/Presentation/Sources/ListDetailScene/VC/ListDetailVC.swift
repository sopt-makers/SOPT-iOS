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
import Domain
import DSKit

import Lottie

public enum TextViewState {
    case inactive // 비활성화(키보드X, placeholder)
    case active // 활성화(키보드O, 텍스트 입력 상태)
    case completed // 작성 완료
}

public class ListDetailVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: ListDetailViewModel!
    public var factory: ModuleFactoryInterface!
    private var cancelBag = CancelBag()
    private var sceneType: ListDetailSceneType {
        get {
            return self.viewModel.listDetailType
        } set(type) {
            self.viewModel.listDetailType = type
        }
    }
    private var starLevel: StarViewLevel {
        return self.viewModel.starLevel
    }
    private var originImage: UIImage = UIImage()
    private var originText: String = ""
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.ListDetail.mission)
        .setRightButton(.none)
    private let contentStackView = UIStackView()
    private lazy var missionView = MissionView(level: starLevel, mission: "미션주세요미션미션미션미션")
    private let missionImageView = UIImageView()
    private let imagePlaceholderLabel = UILabel()
    private let textView = UITextView()
    private let dateLabel = UILabel()
    private lazy var bottomButton = CustomButton(title: sceneType == .none ?  I18N.ListDetail.missionComplete : I18N.ListDetail.editComplte)
        .setEnabled(false)
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setLayout()
        self.setStackView()
        self.setDefaultUI()
        self.setUI(sceneType)
        self.setObserver()
        self.setGesture()
        self.setDelegate()
    }
}

// MARK: - Methods

extension ListDetailVC {
    private func bindViewModels() {
        let rightButtonTapped = naviBar.rightButtonTapped
            .map { self.sceneType }
            .asDriver()
        // TODO: - input, output 정리 (alert tapped action)
        
        let bottomButtonTapped = bottomButton
            .publisher(for: .touchUpInside)
            .map { _ in
                ListDetailRequestModel(imgURL: self.missionImageView.image ?? UIImage(), content: self.textView.text)
            }
            .asDriver()
        
        let input = ListDetailViewModel.Input(bottomButtonTapped: bottomButtonTapped, rightButtonTapped: rightButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.successed
            .sink { successed in
                self.presentCompletedVC(level: self.starLevel)
            }.store(in: self.cancelBag)
        
        output.changeToEdit
            .sink { edit in
                if edit {
                    self.tappedEditButton()
                }
            }.store(in: self.cancelBag)
        
        output.deleteSuccess
            .sink { success in
                let alertVC = self.factory.makeAlertVC(
                    title: I18N.ListDetail.deleteTitle,
                    customButtonTitle: I18N.Default.delete) {
                        print("삭제 서버 통신")
                        self.dismiss(animated: true) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                self.present(alertVC, animated: true)
            }.store(in: self.cancelBag)
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestPhotoLibrary))
        missionImageView.addGestureRecognizer(tapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeDownGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    private func tappedEditButton() {
        self.sceneType = .edit
        self.setUI(sceneType)
    }
    
    private func setDelegate() {
        self.textView.delegate = self
    }
    
    private func openLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        pickerVC.delegate = self
        
        self.present(pickerVC, animated: true)
    }
    
    private func moveToSetting() {
        let alertController = UIAlertController(title: "앨범 접근 권한 거부", message: "앨범 접근이 거부되었습니다. 앱의 일부 기능을 사용할 수 없습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { action in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL)
            }
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        makeVibrate()
        
        self.present(alertController, animated: true)
    }
    
    private func presentCompletedVC(level: StarViewLevel) {
        let missionCompletedVC = MissionCompletedVC()
            .setLevel(level)
        missionCompletedVC.completionHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        missionCompletedVC.modalPresentationStyle = .overFullScreen
        missionCompletedVC.modalTransitionStyle = .crossDissolve
        self.present(missionCompletedVC, animated: true)
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
    private func respondToSwipeDownGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == UISwipeGestureRecognizer.Direction.down {
                self.view.endEditing(true)
            }
        }
    }
    
    @objc
    private func requestPhotoLibrary() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            openLibrary()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                switch newStatus {
                case .authorized, .limited :
                    self.openLibrary()
                case .denied:
                    DispatchQueue.main.async {
                        self.moveToSetting()
                    }
                default:
                    break
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.moveToSetting()
            }
        default:
            print("권한 설정이 이상하게 되었어요")
        }
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
                    if self.textView.hasText && self.textView.text != I18N.ListDetail.memoPlaceHolder { self.bottomButton.setEnabled(true) }
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
        let missionImageViewFilled = missionImageView.image != nil
        self.bottomButton.setEnabled(textView.hasText && missionImageViewFilled)
    }
}

// MARK: - UI & Layout

extension ListDetailVC {
    private func setUI(_ type: ListDetailSceneType) {
        if type == .edit {
            self.naviBar
                .setRightButton(.delete)
                .resetLeftButtonAction {
                    self.sceneType = .completed
                    self.setUI(self.sceneType)
                }
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            originText = textView.text
            originImage = missionImageView.image ?? UIImage()
        } else {
            if textView.text != I18N.ListDetail.memoPlaceHolder && textView.text != originText {
                textView.text = originText
            }
            
            if let image = missionImageView.image,
               image != originImage {
                missionImageView.image = originImage
            }
            self.naviBar.resetLeftButtonAction()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        switch type {
        case .none, .edit:
            self.missionView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.setTextView(.inactive)
            self.imagePlaceholderLabel.isHidden = missionImageView.image == nil ? false : true
            self.missionImageView.isUserInteractionEnabled = true
            self.bottomButton.isHidden = false
            self.dateLabel.isHidden = true
        case .completed:
            self.naviBar.setRightButton(.addRecord)
            self.missionView.backgroundColor = setLevelColor()
            self.setTextView(.completed)
            self.imagePlaceholderLabel.isHidden = true
            self.bottomButton.isHidden = true
            self.dateLabel.isHidden = false
            self.missionImageView.image = DSKitAsset.Assets.splashImg2.image
            self.missionImageView.isUserInteractionEnabled = false
        }
    }
    
    private func setDefaultUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        self.view.backgroundColor = .white
        self.setStatusBarBackgroundColor(.white)
        
        self.missionImageView.backgroundColor = DSKitAsset.Colors.gray50.color
        self.missionImageView.layer.masksToBounds = true
        self.missionImageView.contentMode = .scaleAspectFill
        self.missionImageView.layer.cornerRadius = 9
        
        self.textView.layer.cornerRadius = 12
        self.textView.layer.borderColor = DSKitAsset.Colors.purple300.color.cgColor
        self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        self.imagePlaceholderLabel.textColor = DSKitAsset.Colors.gray500.color
        self.dateLabel.textColor = DSKitAsset.Colors.gray600.color
        
        self.imagePlaceholderLabel.setTypoStyle(.subtitle2)
        self.textView.setTypoStyle(.caption1)
        self.dateLabel.setTypoStyle(.number3)
        
        self.imagePlaceholderLabel.text = I18N.ListDetail.imagePlaceHolder
        self.textView.text = I18N.ListDetail.memoPlaceHolder
        self.dateLabel.text = "2022.10.25"
        
        self.textView.returnKeyType = .done
    }
    
    private func setLevelColor() -> UIColor {
        switch starLevel {
        case .levelOne:
            return DSKitAsset.Colors.pink100.color
        case .levelTwo:
            return DSKitAsset.Colors.purple100.color
        case .levelThree:
            return DSKitAsset.Colors.mint100.color
        }
    }
    
    private func setTextView(_ state: TextViewState) {
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
        
        contentStackView.addArrangedSubviews(missionView, missionImageView, textView)
        
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
    }
}
