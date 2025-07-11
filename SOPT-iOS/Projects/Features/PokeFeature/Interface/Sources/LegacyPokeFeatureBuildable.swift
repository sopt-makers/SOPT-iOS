//
//  LegacyPokeFeatureBuildable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

public protocol LegacyPokeFeatureBuildable {
    func makePokeMain(isRouteFromRoot: Bool) -> LegacyPokeMainPresentable
    func makePokeMyFriends() -> LegacyPokeMyFriendsPresentable
    func makePokeMyFriendsList(relation: PokeRelation) -> LegacyPokeMyFriendsListPresentable
    func makePokeOnboarding() -> LegacyPokeOnboardingPresentable
    func makePokeMessageTemplateBottomSheet(messageType: PokeMessageType) -> LegacyPokeMessageTemplatesPresentable
    func makePokeNotificationList() -> LegacyPokeNotificationPresentable
    func makePokeMakingFriendCompleted(friendName: String) -> PokeMakingFriendCompletedPresentable
    func makePokeAnonymousFriendUpgrade(user: PokeUserModel) -> LegacyPokeAnonymousFriendUpgradePresentable
}
