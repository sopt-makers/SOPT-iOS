//
//  PokeFriendsSectionGroupView.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core
import Domain

public final class PokeFriendsSectionGroupView: UIView {
    
    // MARK: - Properties
        
    lazy var headerRightButtonTap: Driver<PokeRelation> = headerView.rightButtonTap.map { self.relation }.asDriver()
    let kokButtonTap = PassthroughSubject<PokeUserModel?, Never>()
    let profileImageTap = PassthroughSubject<PokeUserModel?, Never>()
    
    private let relation: PokeRelation
    private let maxContentsCount: Int
    
    let cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let headerView = PokeFriendsSectionHeaderView()
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private let emptyView = PokeEmptyView().setText(with: I18N.Poke.MyFriends.emptyViewDescription).then {
        $0.isHidden = true
    }
    
    // MARK: - initialization
    
    init(pokeRelation: PokeRelation, maxContentsCount: Int) {
        self.relation = pokeRelation
        self.maxContentsCount = maxContentsCount
        super.init(frame: .zero)
        self.setUI()
        self.makeContents()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeFriendsSectionGroupView {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private func makeContents() {
        guard self.maxContentsCount > 0 else { return }
        for i in 0..<self.maxContentsCount {
            let profileListView = PokeProfileListView(viewType: .default).setDividerViewIsHidden(to: i == maxContentsCount-1)
            profileListView.isHidden = true
            profileListView
                .kokButtonTap
                .subscribe(self.kokButtonTap)
                .store(in: cancelBag)
            
            profileListView
                .profileImageTap
                .subscribe(self.profileImageTap)
                .store(in: cancelBag)
            self.contentStackView.addArrangedSubview(profileListView)
        }
    }
    
    private func setLayout() {
        self.addSubviews(headerView, contentStackView, emptyView)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(23)
        }
    }
}

extension PokeFriendsSectionGroupView {
    @discardableResult
    public func fillHeader(title: String, description: String) -> Self {
        self.headerView.setTitle(title)
        self.headerView.setDescription(description)
        return self
    }
    
    public func setData(friendsCount: Int, models: [PokeUserModel]) {
        self.headerView.setFriendsCount(friendsCount)
        
        let models = Array(models.prefix(maxContentsCount))
        
        self.emptyView.isHidden = !models.isEmpty
        
        let contentSubviews = contentStackView.arrangedSubviews.compactMap {
           $0 as? PokeProfileListView
        }
                
        for (index, profileListView) in contentSubviews.enumerated() {
            if let model = models[safe: index] {
                profileListView.setData(with: model)
                profileListView.isHidden = false
            } else {
                profileListView.isHidden = true
            }
        }
    }
}
