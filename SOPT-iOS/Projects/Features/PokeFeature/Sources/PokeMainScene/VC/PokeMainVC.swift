//
//  PokeMainVC.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeMainVC: UIViewController, PokeMainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: PokeMainViewModel
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let backButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
    }
    
    private let serviceTitleLabel = UILabel().then {
        $0.font = UIFont.MDS.heading6
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.text = I18N.Poke.poke
    }
    
    private lazy var navigationView = UIStackView(
        arrangedSubviews: [backButton, serviceTitleLabel]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.alignment = .center
    }
    
    private let scrollView = UIScrollView()
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    // MARK: - initialization
    
    public init(viewModel: PokeMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModel()
    }
}

// MARK: - UI & Layout

extension PokeMainVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        self.view.addSubviews(navigationView, scrollView)
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
        
        setScrollViewLayout()
    }
    
    private func setScrollViewLayout() {
        self.scrollView.addSubviews(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 20 * 2)
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension PokeMainVC {
    private func bindViewModel() {
    }
}
