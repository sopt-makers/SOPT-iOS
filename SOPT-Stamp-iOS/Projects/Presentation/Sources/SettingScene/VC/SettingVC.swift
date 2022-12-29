//
//  SettingVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit
import Then

import Core
import DSKit

public class SettingVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: SettingViewModel!
    private var cancelBag = CancelBag()
    public var factory: ModuleFactoryInterface!
    private let resetButtonTapped = PassthroughSubject<Bool, Never>()
  
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.Setting.setting)
    private let collectionViewFlowlayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
     
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.setRegister()
    }
}

// MARK: - Methods

extension SettingVC {
  
    private func bindViewModels() {
        let input = SettingViewModel.Input(
            resetButtonTapped: resetButtonTapped.asDriver())
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.resetSuccessed
            .sink { success in
                if success {
                    self.showToast(message: I18N.Setting.resetSuccess)
                }
            }.store(in: self.cancelBag)
    }
    
    private func setRegister() {
        SettingCVC.register(target: collectionView)
        SettingHeaderView.register(target: collectionView, isHeader: true)
        SettingFooterView.register(target: collectionView, isHeader: false)
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func presentResetAlertVC() {
        let alertVC = self.factory.makeAlertVC(type: .titleWithDesciption,
                                               title: I18N.Setting.resetMissionTitle,
                                               description: I18N.Setting.resetMissionDescription,
                                               customButtonTitle: I18N.Setting.reset)
        alertVC.customAction = {
            self.resetButtonTapped.send(true)
        }
        
        self.present(alertVC, animated: true)
    }
    
    private func showPasswordChangeView() {
        let passwordChangeVC = self.factory.makePasswordChangeVC()
        navigationController?.pushViewController(passwordChangeVC, animated: true)
    }
}

// MARK: - UI & Layout

extension SettingVC {
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        collectionView.contentInset.top = 8
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(naviBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingVC: WithdrawButtonDelegate {
    func withdrawButtonTapped() {
        print("회원 탈퇴")
    }
}

// MARK: - UICollectionView

extension SettingVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("한마디 편집")
            case 1:
               showPasswordChangeView()
            default:
                print("닉네임 변경")
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("개인정보처리방침")
            case 1:
                print("서비스 이용 약관")
            default:
                print("서비스 의견 제안")
            }
        case 2:
            self.presentResetAlertVC()
        default:
            print("로그아웃")
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width
        let height = width*50/335
        return CGSize(width: width, height: height)
    }
}

extension SettingVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3 { return .zero }
        let width = self.collectionView.frame.width
        let height = width*35/335
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section != 3 { return .zero }
        let width = self.collectionView.frame.width
        let height = width*23/335
        return CGSize(width: width, height: height)
    }
}

extension SettingVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionList = viewModel.settingList
        return sectionList[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCVC.className, for: indexPath) as? SettingCVC else { return UICollectionViewCell() }
        let titleList = viewModel.settingList[indexPath.section]
        if indexPath.row == 1 { cell.setLines() }
        if indexPath.row == 2 { cell.setRadius() }
        if indexPath.section == 2 {
            cell.removeArrow()
                .setRadius()
        }
        
        if indexPath.section == 3 {
            cell.changeTextColor(DSKitAsset.Colors.access300.color)
                .setRadius(false)
        }
        cell.setData(titleList[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingHeaderView.className, for: indexPath) as? SettingHeaderView else { return UICollectionReusableView() }
            let headerList = viewModel.sectionList
            header.setData(headerList[indexPath.section])
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingFooterView.className, for: indexPath) as? SettingFooterView else { return UICollectionReusableView() }
            footer.buttonDelegate = self
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}
