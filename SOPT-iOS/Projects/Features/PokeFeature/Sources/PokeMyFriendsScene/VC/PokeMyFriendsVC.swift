//
//  PokeMyFriendsVC.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeMyFriendsVC: UIViewController, PokeMyFriendsViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: PokeMyFriendsViewModel
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Poke.MyFriends.myFriends, font: UIFont.MDS.body2)
 
    
    // MARK: - initialization
    
    public init(viewModel: PokeMyFriendsViewModel) {
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

extension PokeMyFriendsVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    

    private func setLayout() {
        self.view.addSubviews(naviBar)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension PokeMyFriendsVC {
    private func bindViewModel() {
    }
}
