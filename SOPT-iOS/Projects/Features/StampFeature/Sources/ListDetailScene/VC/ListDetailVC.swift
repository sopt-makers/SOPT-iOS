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
import Kingfisher

import Core
import Domain
import DSKit

import Lottie

import BaseFeatureDependency
import StampFeatureInterface

public enum TextViewState {
    case inactive
    case active
    case completed
}

public class ListDetailVC: UIViewController, ListDetailViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: ListDetailViewModel
    private var cancelBag = CancelBag()
    private var sceneType: ListDetailSceneType {
        get {
            return self.viewModel.sceneType
        } set(type) {
            self.viewModel.sceneType = type
        }
    }
    private var starLevel: StarViewLevel {
        return self.viewModel.starLevel
    }
    private var missionTitle: String {
        return self.viewModel.missionTitle
    }
    private var originImage: UIImage = UIImage()
    private var originText: String = ""
    private let deleteButtonTapped = PassthroughSubject<Bool, Never>()
    
    private let imageSelected = PassthroughSubject<Data, Never>()
    private let dateSelected = PassthroughSubject<String, Never>()
    private let textEdited = PassthroughSubject<String, Never>()
    
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?
    
    // MARK: - ListDetailCoordinatable
    
    public var onNaviBackTap: (() -> Void)?
    public var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)?
    
    // MARK: - UI Components
    
    private lazy var naviBar = STNavigationBar(type: .titleWithLeftButton)
        .setTitle(I18N.ListDetail.mission)
        .setRightButton(.none)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentStackView = UIStackView()
    private lazy var missionView = MissionView(level: starLevel, mission: missionTitle)
    private let missionImageView = UIImageView()
    private let imagePlaceholderLabel = UILabel()
    private let textView = UITextView()
    private lazy var missionDateTextField = MissionDateView(frame: self.view.frame)
    private lazy var bottomButton = STCustomButton(title: sceneType == .none ? I18N.ListDetail.missionComplete : I18N.ListDetail.editComplete)
        .setEnabled(false)
        .setColor(bgColor: DSKitAsset.Colors.white.color,
                  disableColor: DSKitAsset.Colors.gray300.color,
                  textColor: DSKitAsset.Colors.black.color,
                  disableTextcolor: DSKitAsset.Colors.black.color
        )
    private lazy var backgroundDimmerView = CustomDimmerView(self)
    
    
    public init(viewModel: ListDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViews()
        self.bindViewModels()
        self.setLayout()
        self.setStackView()
        self.setDefaultUI()
        self.setUI(sceneType)
        self.setObserver()
        self.setGesture()
        self.setDelegate()
        self.hideKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.missionImageView.image = nil
    }
}

// MARK: - Methods

extension ListDetailVC {
    
    private func bindViews() {
        naviBar.leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
    }
    
    private func bindViewModels() {
        let rightButtonTapped = naviBar.rightButtonTapped
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .withUnretained(self)
            .map { owner, _ in
                owner.sceneType
            }
            .asDriver()
        
        let bottomButtonTapped = bottomButton
            .publisher(for: .touchUpInside)
            .withUnretained(self)
            .map { owner, _ in
                if owner.sceneType == .none {
                    owner.showDimmerView()
                }
            }
            .mapVoid()
            .asDriver()
        
        let input = ListDetailViewModel.Input(
            viewDidLoad: Driver.just(()),
            imageSelected: self.imageSelected.eraseToAnyPublisher(),
            dateSelected: dateSelected.asDriver(),
            textEdited: textEdited.asDriver(),
            bottomButtonTapped: bottomButtonTapped,
            rightButtonTapped: rightButtonTapped,
            deleteButtonTapped: deleteButtonTapped.asDriver())
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$listDetailModel
            .compactMap { $0 }
            .withUnretained(self)
            .sink { owner, model in
                if model.image.isEmpty {
                    AlertUtils.presentNetworkAlertVC(theme: .soptamp,animated: true) {
                        owner.backgroundDimmerView.removeFromSuperview()
                    }
                } else {
                    owner.setData(model)
                    if owner.sceneType == .none {
                        owner.onComplete?(owner.starLevel) {
                            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                                owner.backgroundDimmerView.alpha = 0
                            }) { _ in
                                owner.backgroundDimmerView.removeFromSuperview()
                            }
                        }
                    }
                    owner.sceneType = .completed
                    owner.reloadData(owner.sceneType)
                }
            }.store(in: self.cancelBag)
        
        output.editSuccessed
            .withUnretained(self)
            .sink { owner, successed in
                if successed {
                    owner.reloadData(.completed)
                    owner.showToast(message: I18N.ListDetail.editCompletedToast)
                } else {
                    AlertUtils.presentNetworkAlertVC(theme: .soptamp, animated: true)
                }
            }.store(in: self.cancelBag)
        
        output.showDeleteAlert
            .withUnretained(self)
            .sink { owner, delete in
                if delete {
                    owner.presentDeleteAlertVC()
                } else {
                    owner.reloadData(.edit)
                }
            }.store(in: self.cancelBag)
        
        output.deleteSuccessed
            .withUnretained(self)
            .sink { owner, success in
                if success {
                    owner.navigationController?.popViewController(animated: true)
                } else {
                    AlertUtils.presentNetworkAlertVC(theme: .soptamp, animated: true)
                }
            }.store(in: self.cancelBag)
        
        output.bottomButtonEnabled
            .withUnretained(self)
            .sink { owner, buttonEnabled in
                owner.bottomButton.setEnabled(buttonEnabled)
            }.store(in: cancelBag)
        
        output.isLoading
            .withUnretained(self)
            .sink { owner, isLoading in
                isLoading ? owner.showLoading() : owner.stopLoading()
            }.store(in: cancelBag)
    }
    
    private func setData(_ model: ListDetailModel) {
        guard self.sceneType != .none else { return }
        
        if let imageURL = URL(string: model.image) {
            self.missionImageView.setImage(with: imageURL.absoluteString)
        }
        self.missionDateTextField.setText(with: model.activityDate)
        self.missionDateTextField.setIsEnabled(false)
        self.missionDateTextField.setTextFieldView(.inactive)
        self.textView.text = model.content
    }
    
    private func reloadData(_ scenetype: ListDetailSceneType) {
        self.sceneType = scenetype
        self.setUI(self.sceneType)
    }
    
    private func resetData() {
        if textView.text != I18N.ListDetail.memoPlaceHolder && textView.text != originText {
            textView.text = originText
        }
        
        if let image = missionImageView.image {
            if image != originImage {
                missionImageView.image = originImage
            }
        }
    }
    
    private func setObserver() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification as NSNotification)
        }
        
        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification as NSNotification)
        }
        
        self.missionDateTextField.textFieldDidEdited
            .withUnretained(self)
            .sink { owner, date in
                guard let text = owner.missionDateTextField.getText() else { return }
                owner.dateSelected.send(text)
            }
            .store(in: self.cancelBag)
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestPhotoLibrary))
        missionImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setDelegate() {
        self.textView.delegate = self
    }
    
    private func openLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        
        DispatchQueue.main.async {
            let pickerVC = PHPickerViewController(configuration: configuration)
            pickerVC.delegate = self
            
            self.present(pickerVC, animated: true)
        }
    }
    
    private func moveToSetting() {
        let alertController = UIAlertController(title: I18N.Photo.authTitle, message: I18N.Photo.authMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: I18N.Photo.moveToSetting, style: .default) { action in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL)
            }
        }
        let cancelAction = UIAlertAction(title: I18N.Default.ok, style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        makeVibrate()
        
        self.present(alertController, animated: true)
    }
    
    private func presentDeleteAlertVC() {
        AlertUtils.presentAlertVC(
            type: .title,
            theme: .soptamp,
            title: I18N.ListDetail.deleteTitle,
            description: "",
            customButtonTitle: I18N.Default.delete,
            customAction: {
                self.deleteButtonTapped.send(true)
            }
        )
    }
    
    private func showDimmerView() {
        self.backgroundDimmerView.alpha = 0
        
        self.view.addSubview(backgroundDimmerView)
        
        backgroundDimmerView.snp.makeConstraints { make in
            make.edges.greaterThanOrEqualToSuperview()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.backgroundDimmerView.alpha = 1
        }
    }
    
    // MARK: - @objc
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            let scrollPosition = CGPoint(x: 0, y: keyboardSize.height + (UIDevice.current.hasNotch ? -40 : 66))
            self.scrollView.setContentOffset(scrollPosition, animated: true)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        self.scrollView.setContentOffset(.zero, animated: true)
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
            break
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
                    
                    if let imageData = selectedImage.jpegData(compressionQuality: 0.9) {
                        self.imageSelected.send(imageData)
                    }
                    self.imagePlaceholderLabel.isHidden = true
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ListDetailVC: UITextViewDelegate {
    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == I18N.ListDetail.memoPlaceHolder {
            self.textView.text = .none
        }
        setTextView(.active)
        self.textEdited.send(textView.text)
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
        self.textEdited.send(textView.text)
    }
}

// MARK: - UI & Layout

extension ListDetailVC {
    private func setUI(_ type: ListDetailSceneType) {
        if type == .edit {
            self.naviBar
                .setRightButton(.delete)
                .resetLeftButtonAction {
                    self.resetData()
                    self.reloadData(.completed)
                }
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.originText = textView.text
            self.originImage = self.missionImageView.image ?? UIImage()
            self.bottomButton.changeTitle(attributedString: I18N.ListDetail.editComplete)
                .setEnabled(false)
            self.missionDateTextField.setIsEnabled(true)
        } else {
            self.naviBar.resetLeftButtonAction()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.bottomButton.changeTitle(attributedString: I18N.ListDetail.missionComplete)
        }
        
        switch type {
        case .none, .edit:
            self.scrollView.isScrollEnabled = true
            self.missionView.backgroundColor = DSKitAsset.Colors.gray800.color
            self.setTextView(.inactive)
            self.imagePlaceholderLabel.isHidden = missionImageView.image == nil ? false : true
            self.missionImageView.isUserInteractionEnabled = true
            self.bottomButton.isHidden = false
        case .completed:
            self.scrollView.isScrollEnabled = false
            self.scrollView.setContentOffset(.zero, animated: true)
            self.naviBar.setRightButton(.addRecord)
            self.missionView.backgroundColor = DSKitAsset.Colors.gray800.color
            self.setTextView(.completed)
            self.imagePlaceholderLabel.isHidden = true
            self.bottomButton.isHidden = true
            self.missionImageView.isUserInteractionEnabled = false
            self.missionDateTextField.setTextFieldView(.completed)
        }
        
        if viewModel.isOtherUser {
            self.naviBar.hideRightButton()
        }
    }
    
    private func setDefaultUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        self.view.backgroundColor = DSKitAsset.Colors.gray950.color
        
        self.scrollView.keyboardDismissMode = .onDrag
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 32, right: 0)
        
        self.missionImageView.backgroundColor = DSKitAsset.Colors.gray900.color
        self.missionImageView.layer.masksToBounds = true
        self.missionImageView.contentMode = .scaleAspectFill
        self.missionImageView.layer.cornerRadius = 9
        
        self.textView.layer.cornerRadius = 12
        self.textView.layer.borderColor = DSKitAsset.Colors.gray500.color.cgColor
        self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 14)
        
        self.imagePlaceholderLabel.textColor = DSKitAsset.Colors.gray300.color
        self.imagePlaceholderLabel.setTypoStyle(.SoptampFont.subtitle2)
        self.textView.setTypoStyle(.SoptampFont.caption1)
        
        self.imagePlaceholderLabel.text = I18N.ListDetail.imagePlaceHolder
        self.textView.text = I18N.ListDetail.memoPlaceHolder
        
        self.textView.returnKeyType = .done
    }
    
    private func setTextView(_ state: TextViewState) {
        self.textView.backgroundColor = DSKitAsset.Colors.gray900.color
        
        switch state {
        case .inactive:
            self.textView.textColor = DSKitAsset.Colors.gray300.color
            self.textView.layer.borderWidth = .zero
            self.textView.isEditable = true
        case .active:
            self.textView.textColor = DSKitAsset.Colors.white.color
            self.textView.layer.borderWidth = 1
            self.textView.isEditable = true
        case .completed:
            self.textView.textColor = DSKitAsset.Colors.white.color
            self.textView.layer.borderWidth = .zero
            self.textView.isEditable = false
        }
        
        switch sceneType {
        case .edit:
            self.textView.textColor = DSKitAsset.Colors.white.color
        default: return
        }
    }
    
    private func setStackView() {
        self.contentStackView.axis = .vertical
        self.contentStackView.distribution = .fill
        self.contentStackView.spacing = UIDevice.current.hasNotch ? 16 : 14
    }
    
    private func setLayout() {
        self.setScrollViewLayout()
        self.view.addSubviews(scrollView, naviBar)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setStackViewLayout() {
        contentStackView.addArrangedSubviews(missionView, missionImageView, missionDateTextField, textView)
        
        missionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        missionImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.missionImageView.snp.width)
        }
        
        missionDateTextField.snp.makeConstraints {
            $0.height.equalTo(39.f)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.contentStackView.snp.width).multipliedBy(0.39)
        }
        
        contentStackView.addSubview(imagePlaceholderLabel)
        
        imagePlaceholderLabel.snp.makeConstraints { make in
            make.center.equalTo(missionImageView.snp.center)
        }
    }
    
    private func setScrollViewLayout() {
        self.setStackViewLayout()
        
        self.scrollView.addSubviews(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubviews(contentStackView, bottomButton)
        
        contentStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(contentStackView.snp.bottom).offset(UIDevice.current.hasNotch ? 30 : 20)
            make.height.equalTo(56)
        }
    }
}
