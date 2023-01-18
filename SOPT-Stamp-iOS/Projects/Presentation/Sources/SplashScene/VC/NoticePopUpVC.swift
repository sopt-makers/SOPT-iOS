//
//  NoticePopUpVC.swift
//  Presentation
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Core
import DSKit

import SnapKit
import Then

public class NoticePopUpVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    
    // MARK: - UI Components
    
    private lazy var backgroundDimmerView = CustomDimmerView(self)
    
    private let noticeView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let noticeTitleLabel = UILabel().then {
        $0.text = I18N.Notice.notice
        $0.font = .subtitle3
        $0.textColor = DSKitAsset.Colors.purple300.color
        $0.backgroundColor = DSKitAsset.Colors.purple100.color
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
    }
    
    private let noticeContentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .caption3
        $0.textColor = DSKitAsset.Colors.gray900.color
        $0.textAlignment = .center
    }
    
    private let
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

// MARK: - UI & Layout

extension NoticePopUpVC {
    private func setUI() {
        self.view.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.view.addSubviews(backgroundDimmerView)
        
        backgroundDimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
