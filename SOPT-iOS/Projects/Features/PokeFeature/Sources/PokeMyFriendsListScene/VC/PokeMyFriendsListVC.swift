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
    
    private let headerView = PokeFriendsSectionHeaderView()
        .setRightButtonImage(with: DSKitAsset.Assets.xClose.image)
    
    private let tableView = UITableView()
    
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
        self.setTableView()
        self.setLayout()
        self.bindViewModel()
    }
}

// MARK: - UI & Layout

extension PokeMyFriendsListVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray800.color
        headerView.setTitle(viewModel.relation.title)
        headerView.setDescription(viewModel.relation.friendBaselineDescription)
    }
    
    private func setLayout() {
        self.view.addSubviews(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: - Methods

extension PokeMyFriendsListVC {
    private func bindViewModel() {
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PokeMyFriendsListVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
