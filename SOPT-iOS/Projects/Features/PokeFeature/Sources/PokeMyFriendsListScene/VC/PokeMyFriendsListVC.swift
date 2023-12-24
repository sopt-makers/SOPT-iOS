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
    
    private let reachToBottomSubject = PassthroughSubject<Void, Never>()
    private let kokButtonTap = PassthroughSubject<PokeUserModel?, Never>()
    private let profileImageTap = PassthroughSubject<PokeUserModel?, Never>()
    
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
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.gray800.color
        tableView.backgroundColor = .clear
        headerView.setTitle(viewModel.relation.title)
        headerView.setDescription(viewModel.relation.friendBaselineDescription)
    }
    
    private func setLayout() {
        self.view.addSubviews(headerView, tableView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PokeMyFriendsListTVC.self, forCellReuseIdentifier: PokeMyFriendsListTVC.className)
        self.tableView.separatorStyle = .none
    }
}

// MARK: - Methods

extension PokeMyFriendsListVC {
    private func bindViewModel() {
        let input = PokeMyFriendsListViewModel.Input(viewDidLoad: Just(()).asDriver(),
                                                     closeButtonTap: self.headerView.rightButtonTap,
                                                     reachToBottom: self.reachToBottomSubject.asDriver(), 
                                                     pokeButtonTap: self.kokButtonTap.asDriver(), 
                                                     profileImageTap: self.profileImageTap.asDriver())
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.friendCount
            .sink { [weak self] count in
                self?.headerView.setFriendsCount(count)
            }.store(in: cancelBag)
        
        output.needToReloadFriendList
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: cancelBag)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PokeMyFriendsListVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeMyFriendsListTVC.className, for: indexPath) 
                as? PokeMyFriendsListTVC 
        else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.setData(model: viewModel.friends[indexPath.row])
        
        cell.kokButtonTap
            .subscribe(self.kokButtonTap)
            .store(in: cell.cancelBag)
        
        cell.profileImageTap
            .subscribe(self.profileImageTap)
            .store(in: cell.cancelBag)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        guard offsetY > 0 , contentHeight > 0 else { return }
        
        if height > contentHeight - offsetY {
            self.reachToBottomSubject.send()
        }
    }
}
