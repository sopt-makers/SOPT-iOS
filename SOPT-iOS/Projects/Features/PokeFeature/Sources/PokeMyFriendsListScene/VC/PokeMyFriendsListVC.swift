//
//  PokeMyFriendsListVC.swift
//  PokeFeatureDemo
//
//  Created by sejin on 12/21/23.
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

public final class PokeMyFriendsListVC: UIViewController, PokeMyFriendsListViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: PokeMyFriendsListViewModel
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    // MARK: - initialization
    
    public init(viewModel: PokeMyFriendsListViewModel) {
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

extension PokeMyFriendsListVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
    }
}

// MARK: - Methods

extension PokeMyFriendsListVC {
    private func bindViewModel() {
    }
}
