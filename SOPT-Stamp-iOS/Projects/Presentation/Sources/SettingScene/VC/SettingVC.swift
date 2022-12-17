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
        let input = SettingViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
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

// MARK: - UICollectionView

extension SettingVC: UICollectionViewDelegate {
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
        if indexPath.section == 2 || indexPath.section == 3 {
            cell.removeArrow()
                .setRadius()
        }
        if indexPath.section == 3 {
            cell.changeTextColor(DSKitAsset.Colors.access300.color)
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
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}
