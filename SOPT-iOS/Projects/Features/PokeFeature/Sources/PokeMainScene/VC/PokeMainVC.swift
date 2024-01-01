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
    
    private lazy var scrollView = UIScrollView().then {
        $0.refreshControl = self.refreshControl
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    // 누가 나를 찔렀어요 부분
    private let pokedSectionHeaderView = PokeMainSectionHeaderView(title: I18N.Poke.someonePokedMe)
    private let pokedUserContentView = PokeNotificationListContentView(frame: .zero)
    private lazy var pokedSectionGroupView = self.makeSectionGroupView(header: pokedSectionHeaderView, content: pokedUserContentView).then {
        $0.isHidden = true
    }
    
    // 내 친구를 찔러보세요 부분
    private let friendSectionHeaderView = PokeMainSectionHeaderView(title: I18N.Poke.pokeMyFriends)
    private let friendSectionContentView = PokeProfileListView(viewType: .main)
    private lazy var friendSectionGroupView = self.makeSectionGroupView(header: friendSectionHeaderView, content: friendSectionContentView)
    
    // 내 친구의 친구를 찔러보세요 부분
    private let recommendPokeLabel = UILabel().then {
        $0.text = I18N.Poke.pokeNearbyFriends
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.font = UIFont.MDS.title5
    }
    
    private let firstProfileCardGroupView = ProfileCardGroupView(frame: .zero)
    
    private let secondProfileCardGroupView = ProfileCardGroupView(frame: .zero)
    
    // 리프레시
    private let refreshGuideLabel = UILabel().then {
        $0.font = UIFont.MDS.title7
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.text = I18N.Poke.refreshGuide
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let refreshControl = UIRefreshControl()
    
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
        self.setDelegate()
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
    
    private func setDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setStackView() {
        self.contentStackView.addArrangedSubviews(pokedSectionGroupView,
                                                  friendSectionGroupView,
                                                  recommendPokeLabel,
                                                  firstProfileCardGroupView,
                                                  secondProfileCardGroupView,
                                                  refreshGuideLabel)
        
        contentStackView.setCustomSpacing(28, after: friendSectionGroupView)
        contentStackView.setCustomSpacing(12, after: secondProfileCardGroupView)
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
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setFriendRandomUsers(with randomUsers: [PokeFriendRandomUserModel]) {
        let profileCardGroupViews = [firstProfileCardGroupView, secondProfileCardGroupView]
        recommendPokeLabel.isHidden = randomUsers.isEmpty
        for (i, profileCardGroupView) in profileCardGroupViews.enumerated() {
            let randomUser = randomUsers[safe: i]
            profileCardGroupView.isHidden = (randomUser == nil)
            if let randomUser {
                profileCardGroupView.setData(with: randomUser)
            }
        }
    }
}

extension PokeMainVC: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewControllers = self.navigationController?.viewControllers else { return false }
        return viewControllers.count > 1
    }
}

// MARK: - Methods

extension PokeMainVC {
    private func bindViewModel() {
        let profileImageTap = Publishers.Merge4(pokedUserContentView.profileImageTap,
                                                friendSectionContentView.profileImageTap,
                                                firstProfileCardGroupView.profileImageTap,
                                                secondProfileCardGroupView.profileImageTap).asDriver()
        
        let randomUserSectionFriendProfileImageTap = Publishers.Merge(
            firstProfileCardGroupView.friendProfileImageTap,
            secondProfileCardGroupView.friendProfileImageTap
        ).asDriver()
        
        let input = PokeMainViewModel
            .Input(
                viewDidLoad: Just(()).asDriver(),
                naviBackButtonTap: self.backButton
                    .publisher(for: .touchUpInside)
                    .mapVoid().asDriver(),
                pokedSectionHeaderButtonTap: pokedSectionHeaderView
                    .rightButtonTap,
                friendSectionHeaderButtonTap: friendSectionHeaderView
                    .rightButtonTap,
                pokedSectionKokButtonTap: pokedUserContentView
                    .kokButtonTap,
                friendSectionKokButtonTap: friendSectionContentView
                    .kokButtonTap,
                nearbyFriendsSectionKokButtonTap: firstProfileCardGroupView
                    .kokButtonTap
                    .merge(with: secondProfileCardGroupView.kokButtonTap)
                    .asDriver(),
                refreshRequest: refreshControl.publisher(for: .valueChanged).mapVoid().asDriver(),
                profileImageTap: profileImageTap,
                randomUserSectionFriendProfileImageTap: randomUserSectionFriendProfileImageTap
            )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.pokedToMeUser
            .withUnretained(self)
            .sink { owner, model in
                owner.pokedUserContentView.configure(with: model)
            }.store(in: cancelBag)
        
        output.pokedUserSectionWillBeHidden
            .assign(to: \.isHidden, onWeak: pokedSectionGroupView)
            .store(in: cancelBag)
        
        output.myFriend
            .withUnretained(self)
            .sink { owner, model in
                owner.friendSectionContentView.setData(with: model)
            }.store(in: cancelBag)
        
        output.friendsSectionWillBeHidden
            .assign(to: \.isHidden, onWeak: friendSectionGroupView)
            .store(in: cancelBag)
        
        output.friendRandomUsers
            .withUnretained(self)
            .sink { owner, randomUsers in
                owner.setFriendRandomUsers(with: randomUsers)
            }.store(in: cancelBag)
        
        output.endRefreshLoading
            .withUnretained(self)
            .sink { owner, _ in
                owner.refreshControl.endRefreshing()
            }.store(in: cancelBag)
        
        output.pokeResponse
            .withUnretained(self)
            .sink { owner, updatedUser in
                let pokeUserViews = [owner.pokedUserContentView,
                                     owner.friendSectionContentView,
                                     owner.firstProfileCardGroupView,
                                     owner.secondProfileCardGroupView]
                    .compactMap { $0 as? PokeCompatible }
                
                pokeUserViews.forEach { pokeUserView in
                    pokeUserView.changeUIAfterPoke(newUserModel: updatedUser)
                }
            }.store(in: cancelBag)
        
        output.isLoading
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.stopLoading()
            }.store(in: self.cancelBag)
    }
}
