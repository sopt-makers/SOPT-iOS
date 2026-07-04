//
//  SoptletterRepositoryInterface.swift
//  Domain
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public protocol SoptletterRepositoryInterface {
    func writeMessage(topicId: Int, content: String) async throws
<<<<<<< HEAD
    func fetchTopics() async throws -> SoptletterTopicListModel
    func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailModel
=======
<<<<<<< HEAD
    func getSoptletterProfile() async throws -> SoptletterProfileModel
    func completeOnboarding() async throws
=======
    func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemModel
    func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel
>>>>>>> develop
>>>>>>> develop
}
