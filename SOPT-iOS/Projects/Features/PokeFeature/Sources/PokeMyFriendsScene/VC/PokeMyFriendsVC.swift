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
        .setLeftButtonImage(DSKitAsset.Assets.chevronLeft.image.withTintColor(DSKitAsset.Colors.gray30.color))
 
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentStackView = UIStackView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray900.color
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let newFriendsSectionView = PokeFriendsSectionGroupView(pokeRelation: .newFriend, maxContentsCount: 2)
        .fillHeader(title: I18N.Poke.MyFriends.newFriends, description: I18N.Poke.MyFriends.friendsBaseline(2))
    
    private let bestFriendsSectionView = PokeFriendsSectionGroupView(pokeRelation: .bestFriend, maxContentsCount: 2)
        .fillHeader(title: I18N.Poke.MyFriends.bestFriend, description: I18N.Poke.MyFriends.friendsBaseline(5))
    
    private let soulmateSectionView = PokeFriendsSectionGroupView(pokeRelation: .soulmate, maxContentsCount: 2)
        .fillHeader(title: I18N.Poke.MyFriends.soulmate, description: I18N.Poke.MyFriends.friendsBaseline(11))
    
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
        self.setStackView()
        self.setLayout()
        self.bindViewModel()
    }
}

// MARK: - UI & Layout

extension PokeMyFriendsVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setStackView() {
        self.contentStackView.addArrangedSubviews(newFriendsSectionView, bestFriendsSectionView, soulmateSectionView)
    }

    private func setLayout() {
        self.view.addSubviews(naviBar, scrollView)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        setScrollViewLayout()
    }
    
    private func setScrollViewLayout() {
        self.scrollView.addSubviews(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Methods

extension PokeMyFriendsVC {
    private func bindViewModel() {
        let moreFriendListButtonTap = Publishers.Merge3(newFriendsSectionView.headerRightButtonTap,
                                                       bestFriendsSectionView.headerRightButtonTap,
                                                        soulmateSectionView.headerRightButtonTap).asDriver()
        
        let input = PokeMyFriendsViewModel.Input(moreFriendListButtonTap: moreFriendListButtonTap)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        // TODO: 임시로 데이터를 넣기 위한 코드 -> 서버 연결 후 제거 예정
        self.newFriendsSectionView.setData(friendsCount: 84, models: [.init(userId: 1, avatarUrl: "", name: "가나다", partInfomation: "33기 안드로이드", pokeCount: 4, relation: .newFriend), .init(userId: 2, avatarUrl: "", name: "가나다", partInfomation: "33기 안드로이드", pokeCount: 4, relation: .newFriend)])
        
        self.bestFriendsSectionView.setData(friendsCount: 100, models: [.init(userId: 3, avatarUrl: "", name: "가나다", partInfomation: "33기 안드로이드", pokeCount: 4, relation: .newFriend), .init(userId: 4, avatarUrl: "", name: "가나다", partInfomation: "33기 서버", pokeCount: 4, relation: .newFriend)])
        
        self.soulmateSectionView.setData(friendsCount: 2, models: [])
    }
}
