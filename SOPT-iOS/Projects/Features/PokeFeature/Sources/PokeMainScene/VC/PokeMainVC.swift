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
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    private let pokedSectionHeaderView = PokeMainSectionHeaderView(title: I18N.Poke.someonePokedMe)
    private let pokedUserContentView = PokeNotificationListContentView(frame: .zero)
    private lazy var pokedSectionGroupView = self.makeSectionGroupView(header: pokedSectionHeaderView, content: pokedUserContentView)
    
    private let friendSectionHeaderView = PokeMainSectionHeaderView(title: I18N.Poke.pokeMyFriends)
    private let friendSectionContentView = PokeProfileListView(viewType: .main)
    private lazy var friendSectionGroupView = self.makeSectionGroupView(header: friendSectionHeaderView, content: friendSectionContentView)
    
    private let recommendPokeLabel = UILabel().then {
        $0.text = I18N.Poke.pokeNearbyFriends
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.font = UIFont.MDS.title5
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
        self.setStackView()
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
    
    private func setStackView() {
        self.contentStackView.addArrangedSubviews(pokedSectionGroupView, friendSectionGroupView, recommendPokeLabel)
        
        contentStackView.setCustomSpacing(28, after: friendSectionGroupView)
    }
    
    private func makeSectionGroupView(header: PokeMainSectionHeaderView, content: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray900.color
        view.addSubviews(header, content)
        view.layer.cornerRadius = 12
        
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
        }
        
        return view
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
        let input = PokeMainViewModel
            .Input(
                naviBackButtonTap: self.backButton
                    .publisher(for: .touchUpInside)
                    .mapVoid().asDriver()
            )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
    }
}
