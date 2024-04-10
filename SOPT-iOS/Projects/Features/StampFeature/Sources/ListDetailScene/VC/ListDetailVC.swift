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

extension StarViewLevel {
  var buttonTitleColor: UIColor {
    switch self {
    case .levelOne, .levelTwo:
      return DSKitAsset.Colors.soptampWhite.color
    case .levelThree:
      return DSKitAsset.Colors.soptampGray700.color
    }
  }
  
  var pointColor: UIColor {
    switch self {
    case .levelOne:
      return DSKitAsset.Colors.soptampPink300.color
    case .levelTwo:
      return DSKitAsset.Colors.soptampPurple300.color
    case .levelThree:
      return DSKitAsset.Colors.soptampMint300.color
    }
  }
  
  var disableColor: UIColor {
    switch self {
    case .levelOne:
      return DSKitAsset.Colors.soptampPink200.color
    case .levelTwo:
      return DSKitAsset.Colors.soptampPurple200.color
    case .levelThree:
      return DSKitAsset.Colors.soptampMint200.color
    }
  }
  
  var bgColor: UIColor {
    switch self {
    case .levelOne:
      return DSKitAsset.Colors.soptampPink100.color
    case .levelTwo:
      return DSKitAsset.Colors.soptampPurple100.color
    case .levelThree:
      return DSKitAsset.Colors.soptampMint100.color
    }
  }
}

public class ListDetailVC: UIViewController, ListDetailViewControllable {
  
  // MARK: - Properties
  
  public var viewModel: ListDetailViewModel!
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
  
  // MARK: - ListDetailCoordinatable
  
  public var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)?
  
  // MARK: - UI Components
  
  private lazy var naviBar = STNavigationBar(self, type: .titleWithLeftButton)
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
  private let dateLabel = UILabel()
  private lazy var bottomButton = STCustomButton(title: sceneType == .none ? I18N.ListDetail.missionComplete : I18N.ListDetail.editComplete)
    .setEnabled(false)
    .setColor(bgColor: starLevel.pointColor,
              disableColor: starLevel.disableColor,
              textColor: starLevel.buttonTitleColor)
  private lazy var backgroundDimmerView = CustomDimmerView(self)
  
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
    self.hideKeyboard()
  }
}

// MARK: - Methods

extension ListDetailVC {
  private func bindViewModels() {
    let rightButtonTapped = naviBar.rightButtonTapped
      .map { self.sceneType }
      .asDriver()
    
    let bottomButtonTapped = bottomButton
      .publisher(for: .touchUpInside)
      .map { _ in
        if self.sceneType == .edit {
          self.bottomButton.setEnabled(false)
        }
        if self.sceneType == .none {
          self.showDimmerView()
        }
        let content = self.textView.text
        return ListDetailRequestModel(
          missionId: self.viewModel.missionId ?? 0,
          content: content ?? "",
          activityDate: self.missionDateTextField.getText() ?? ""
        )
      }
      .asDriver()
    
    let input = ListDetailViewModel.Input(
      viewDidLoad: Driver.just(()), 
      imageSelected: self.imageSelected.eraseToAnyPublisher(),
      bottomButtonTapped: bottomButtonTapped,
      rightButtonTapped: rightButtonTapped,
      deleteButtonTapped: deleteButtonTapped.asDriver())
    
    let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    
    output.$listDetailModel
      .compactMap { $0 }
      .sink { model in
        if model.image.isEmpty {
          AlertUtils.presentNetworkAlertVC(theme: .soptamp,animated: true) {
            self.backgroundDimmerView.removeFromSuperview()
          }
        } else {
          self.setData(model)
          if self.sceneType == .none {
            self.onComplete?(self.starLevel) {
              UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.backgroundDimmerView.alpha = 0
              }) { _ in
                self.backgroundDimmerView.removeFromSuperview()
              }
            }
          }
          self.sceneType = .completed
          self.reloadData(self.sceneType)
        }
      }.store(in: self.cancelBag)
    
    output.editSuccessed
      .sink { successed in
        if successed {
          self.reloadData(.completed)
          self.showToast(message: I18N.ListDetail.editCompletedToast)
        } else {
          AlertUtils.presentNetworkAlertVC(theme: .soptamp, animated: true)
        }
      }.store(in: self.cancelBag)
    
    output.showDeleteAlert
      .sink { delete in
        if delete {
          self.presentDeleteAlertVC()
        } else {
          self.reloadData(.edit)
        }
      }.store(in: self.cancelBag)
    
    output.deleteSuccessed
      .sink { success in
        if success {
          self.navigationController?.popViewController(animated: true)
        } else {
          AlertUtils.presentNetworkAlertVC(theme: .soptamp, animated: true)
        }
      }.store(in: self.cancelBag)
  }
  
  private func setData(_ model: ListDetailModel) {
    guard self.sceneType != .none else { return }
    
    if let imageURL = URL(string: model.image) {
      self.missionImageView.kf.setImage(with: imageURL)
    }
    self.missionDateTextField.setText(with: model.activityDate)
    self.missionDateTextField.setIsEnabled(false)
    self.missionDateTextField.setTextFieldView(.inactive)
    self.textView.text = model.content
    self.dateLabel.text = model.date
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
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
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
          if self.textView.hasText && self.textView.text != I18N.ListDetail.memoPlaceHolder { self.bottomButton.setEnabled(true)
          }
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
    self.bottomButton.setEnabled(textView.hasText && missionImageViewFilled && textView.text != originText)
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
      self.missionView.backgroundColor = DSKitAsset.Colors.soptampGray50.color
      self.setTextView(.inactive)
      self.imagePlaceholderLabel.isHidden = missionImageView.image == nil ? false : true
      self.missionImageView.isUserInteractionEnabled = true
      self.bottomButton.isHidden = false
      self.dateLabel.isHidden = true
    case .completed:
      self.scrollView.isScrollEnabled = false
      self.scrollView.setContentOffset(.zero, animated: true)
      self.naviBar.setRightButton(.addRecord)
      self.missionView.backgroundColor = starLevel.bgColor
      self.setTextView(.completed)
      self.imagePlaceholderLabel.isHidden = true
      self.bottomButton.isHidden = true
      self.dateLabel.isHidden = false
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
    
    self.view.backgroundColor = .white
    
    self.scrollView.keyboardDismissMode = .onDrag
    self.scrollView.showsVerticalScrollIndicator = false
    self.scrollView.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 32, right: 0)
    
    self.missionImageView.backgroundColor = DSKitAsset.Colors.soptampGray50.color
    self.missionImageView.layer.masksToBounds = true
    self.missionImageView.contentMode = .scaleAspectFill
    self.missionImageView.layer.cornerRadius = 9
    
    self.textView.layer.cornerRadius = 12
    self.textView.layer.borderColor = starLevel.pointColor.cgColor
    self.missionDateTextField.setBorderLayerColor(to: starLevel.pointColor.cgColor)
    self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    
    self.imagePlaceholderLabel.textColor = DSKitAsset.Colors.soptampGray500.color
    self.dateLabel.textColor = DSKitAsset.Colors.soptampGray600.color
    
    self.imagePlaceholderLabel.setTypoStyle(.SoptampFont.subtitle2)
    self.textView.setTypoStyle(.SoptampFont.caption1)
    self.dateLabel.setTypoStyle(.SoptampFont.number3)
    
    self.imagePlaceholderLabel.text = I18N.ListDetail.imagePlaceHolder
    self.textView.text = I18N.ListDetail.memoPlaceHolder
    
    self.textView.returnKeyType = .done
  }
  
  private func setTextView(_ state: TextViewState) {
    switch state {
    case .inactive:
      self.textView.backgroundColor = DSKitAsset.Colors.soptampGray50.color
      self.textView.textColor = DSKitAsset.Colors.soptampGray600.color
      self.textView.layer.borderWidth = .zero
      self.textView.isEditable = true
    case .active:
      self.textView.backgroundColor = DSKitAsset.Colors.soptampWhite.color
      self.textView.textColor = DSKitAsset.Colors.soptampGray900.color
      self.textView.layer.borderWidth = 1
      self.textView.isEditable = true
    case .completed:
      self.textView.backgroundColor = DSKitAsset.Colors.soptampGray50.color
      self.textView.textColor = DSKitAsset.Colors.soptampGray900.color
      self.textView.layer.borderWidth = .zero
      self.textView.isEditable = false
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
      make.height.equalTo(64)
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
    
    self.contentView.addSubviews(contentStackView, dateLabel, bottomButton)
    
    contentStackView.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
    }
    
    dateLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.top.equalTo(contentStackView.snp.bottom).offset(12)
    }
    
    bottomButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(contentStackView.snp.bottom).offset(UIDevice.current.hasNotch ? 30 : 20)
      make.height.equalTo(56)
    }
  }
}
