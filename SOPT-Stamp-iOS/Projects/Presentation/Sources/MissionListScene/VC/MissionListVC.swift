//
//  MissionListVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

public class MissionListVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: MissionListViewModel!
    public var sceneType: MissionListSceneType {
        return self.viewModel.missionListsceneType
    }
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    lazy var naviBar: CustomNavigationBar = {
        switch sceneType {
        case .default:
            return CustomNavigationBar(self, type: .title)
                .setTitle("전체 미션")
                .setTitleTypoStyle(.h2)
        case .ranking(let username):
            return CustomNavigationBar(self, type: .titleWithLeftButton)
                .setTitle(username)
                .setRightButton(.none)
                .setTitleTypoStyle(.h2)
        }
    }()
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModels()
    }
}

// MARK: - UI & Layouts

extension MissionListVC {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
    }
}

// MARK: - Methods

extension MissionListVC {
    
    private func bindViewModels() {
        let input = MissionListViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
}
