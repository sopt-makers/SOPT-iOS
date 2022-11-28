//
//  ListDetailVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit
import Then

import Core
import DSKit

public class ListDetailVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: ListDetailViewModel!
    public var factory: ModuleFactoryInterface!
    private var cancelBag = CancelBag()
  
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
    private let bottomButton = CustomButton(title: I18N.ListDetail.missionComplete).setEnabled(false)
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .white
        self.missionView.backgroundColor = DSKitAsset.Colors.gray50.color
        self.missionImageView.backgroundColor = DSKitAsset.Colors.gray50.color
        self.textView.backgroundColor = DSKitAsset.Colors.gray50.color
        
        self.missionView.layer.cornerRadius = 9
        self.missionImageView.layer.cornerRadius = 9
        self.textView.layer.cornerRadius = 12
        self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        self.missionLabel.textColor = DSKitAsset.Colors.gray900.color
        self.imagePlaceholderLabel.textColor = DSKitAsset.Colors.gray500.color
        
        self.missionLabel.setTypoStyle(.subtitle1)
        self.imagePlaceholderLabel.setTypoStyle(.subtitle2)
        self.textView.setTypoStyle(.caption1)
        
        self.contentStackView.axis = .vertical
        self.contentStackView.distribution = .fill
        self.contentStackView.spacing = 16
        
        self.starStackView.axis = .horizontal
        self.starStackView.distribution = .fillEqually
        self.starStackView.spacing = 10
        
        [self.firstStarImageView, self.secondStarImageView, self.thirdStarImageView].forEach { $0.backgroundColor = DSKitAsset.Colors.mint.color }
        
        self.missionLabel.text = "앱잼 팀원 다 함께 바다 보고 오기"
        self.imagePlaceholderLabel.text = I18N.ListDetail.imagePlaceHolder
        self.textView.text = I18N.ListDetail.memoPlaceHolder
    }
    
    private func setLayout() {
        self.view.addSubviews([naviBar, contentStackView,
                               imagePlaceholderLabel, bottomButton])
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(naviBar.snp.bottom).offset(7)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(56)
        }
        
        contentStackView.addArrangedSubviews([missionView, missionImageView, textView])
        
        missionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
//            make.height.equalTo(self.missionView.snp.width).multipliedBy(0.19)
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

// MARK: - Methods

extension ListDetailVC {
  
    private func bindViewModels() {
        let input = ListDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
