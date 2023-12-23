//
//  PokeMyFriendsListTVC.swift
//  PokeFeature
//
//  Created by sejin on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import Domain

final class PokeMyFriendsListTVC: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var kokButtonTap: Driver<PokeUserModel?> = self.profileListView.kokButtonTap
    lazy var profileImageTap: Driver<PokeUserModel?> = self.profileListView.profileImageTap
    let cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let profileListView = PokeProfileListView(viewType: .default)
        .setDividerViewIsHidden(to: false)
        .setDividerViewColor(with: DSKitAsset.Colors.gray700.color)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension PokeMyFriendsListTVC {
    
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        self.contentView.addSubviews(profileListView)
        
        profileListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension PokeMyFriendsListTVC {
    func setData(model: PokeUserModel) {
        profileListView.setData(with: model)
    }
    
    override func prepareForReuse() {
        self.cancelBag.cancel()
    }
}
