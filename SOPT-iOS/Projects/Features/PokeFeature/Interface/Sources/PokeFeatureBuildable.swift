//
//  PokeFeatureBuildable.swift
//  PokeFeatureInterface
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import BaseFeatureDependency

public protocol PokeFeatureBuildable {
    func makePokeMain(isRouteFromRoot: Bool, isRouteFromTabBar: Bool, coordinator: Coordinator) -> PokeMainPresentable
    func makePokeMyFriends(coordinator: Coordinator) -> PokeMyFriendsPresentable
    func makePokeMyFriendsList(relation: PokeRelation) -> PokeMyFriendsListPresentable
    func makePokeOnboarding(coordinator: AnyCoordinatorObject) -> PokeOnboardingPresentable
    func makePokeMessageTemplateBottomSheet(messageType: PokeMessageType, config: PokeMessageTemplateConfig) -> PokeMessageTemplatesPresentable
    func makePokeNotificationList(coordinator: Coordinator) -> PokeNotificationPresentable
    func makePokeMakingFriendCompleted(friendName: String) -> PokeMakingFriendCompletedPresentable
    func makePokeAnonymousFriendUpgrade(user: PokeUserModel) -> PokeAnonymousFriendUpgradePresentable
}

