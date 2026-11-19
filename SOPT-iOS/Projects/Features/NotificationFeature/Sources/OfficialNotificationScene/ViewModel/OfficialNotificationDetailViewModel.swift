//
//  OfficialNotificationDetailViewModel.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/19/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain

import BaseFeatureDependency
import NotificationFeatureInterface

public class OfficialNotificationDetailViewModel: ObservableObject, OfficialNotificationDetailRoutingTrigger {

    // MARK: - State

    @Published var notificationTitle: String = "SOPT Playground 멘토링 오픈 공지"
    @Published var createdDate: String =  "2026.10.31 18:00"
    @Published var notificationText: String = "안녕하세요 ☺️ 플레이그라운드 팀입니다.\n플레이그라운드의 새로운 기능으로 SOPT 회원들 간의 멘토링을 경험하실 수 있습니다. 여러 분야의 멘토분들이 취업준비, 커리어 고민 등 다양한 주제로 멘티분들을 기다리고 있으니 많은 관심 부탁드립니다! 🙌 \n(인원 제한이 있어 빠르게 마감 될 수 있습니다.)"
    @Published var imageUrls: [String] = ["이미지1", "이미지2", "이미지3", "이미지4"]

    // MARK: - Trigger

    public var onCheckButtonTap: (() -> Void)?
    public var onLinkButtonTap: ((NotificationFeatureInterface.ShortCutLink) -> Void)?
    public var onCheckedMemberListTap: (() -> Void)?
    public var onZoomInButtonTap: ((String) -> Void)?

    // MARK: - Action
}
