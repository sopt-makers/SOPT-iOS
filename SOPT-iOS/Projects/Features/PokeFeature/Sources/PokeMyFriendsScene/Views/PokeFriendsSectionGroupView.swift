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

public final class PokeFriendsSectionGroupView: UIView {
    
    // MARK: - Properties
    
    typealias UserId = String
    
    lazy var headerRightButtonTap: Driver<PokeRelation> = headerView.rightButtonTap.map { self.relation }.asDriver()
    lazy var kokButtonTap = PassthroughSubject<UserId?, Never>()
    
    private let relation: PokeRelation
    private let maxContentsCount: Int
    
    // MARK: - UI Components
    
    private let headerView = PokeFriendsSectionHeaderView()
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
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
        self.backgroundColor = .clear
    }
    
    private func makeContents() {
        guard self.maxContentsCount > 0 else { return }
        for _ in 0..<self.maxContentsCount {
            let profileListView = PokeProfileListView(viewType: .default).setDividerViewIsHidden(to: false)
            profileListView.isHidden = true
            self.contentStackView.addArrangedSubview(profileListView)
        }
    }
    
    private func setLayout() {
        self.addSubviews(headerView, contentStackView)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
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
    
    public func setData(friendsCount: Int, models: [ProfileListContentModel]) {
        self.headerView.setFriendsCount(friendsCount)
        
        let models = Array(models.prefix(maxContentsCount))
        
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
