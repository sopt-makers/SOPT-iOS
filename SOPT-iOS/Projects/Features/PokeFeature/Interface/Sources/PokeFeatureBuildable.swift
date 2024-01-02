//
//  PokeFeatureBuildable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

public protocol PokeFeatureBuildable {
    func makePokeMain(isRouteFromRoot: Bool) -> PokeMainPresentable
    func makePokeMyFriends() -> PokeMyFriendsPresentable
    func makePokeMyFriendsList(relation: PokeRelation) -> PokeMyFriendsListPresentable
    func makePokeOnboarding() -> PokeOnboardingPresentable
    func makePokeMessageTemplateBottomSheet(messageType: PokeMessageType) -> PokeMessageTemplatesPresentable
    func makePokeNotificationList() -> PokeNotificationPresentable
    func makePokeMakingFriendCompleted(friendName: String) -> PokeMakingFriendCompletedPresentable
}
