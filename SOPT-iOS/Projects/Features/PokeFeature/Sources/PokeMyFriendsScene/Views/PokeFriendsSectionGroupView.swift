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
    
    public lazy var rightButtonTap: Driver<PokeRelation> = headerView.rightButtonTap.map { self.relation }.asDriver()
    
    private let relation: PokeRelation
    
    // MARK: - UI Components
    
    private let headerView = PokeFriendsSectionHeaderView()
    
    // MARK: - initialization
    
    init(pokeRelation: PokeRelation, maxContentsCount: Int) {
        self.relation = pokeRelation
        super.init(frame: .zero)
        self.setUI()
        self.makeContents(count: maxContentsCount)
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
    
    private func makeContents(count: Int) {
        // 셀 넣기
    }
    
    private func setLayout() {
        self.addSubviews(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
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
}
