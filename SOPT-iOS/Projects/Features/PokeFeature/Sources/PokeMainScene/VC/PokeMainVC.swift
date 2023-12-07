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
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
        return button
    }()
    
    private let serviceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.MDS.heading6
        label.textColor = DSKitAsset.Colors.gray30.color
        label.text = I18N.Poke.poke
        return label
    }()
    
    private lazy var navigationView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, serviceTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()
    
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
        self.view.addSubviews(navigationView)
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
    }
}

// MARK: - Methods

extension PokeMainVC {
    private func bindViewModel() {
    }
}
