//
//  DummyPosts.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 6/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

extension HomeForMemberVC {
    func createDummyPlaygroundNewsPosts() -> [HomePresentationModel.PlaygroundNews] {
        return [
            HomePresentationModel.PlaygroundNews(
                title: "첫 번째 플레이그라운드 뉴스",
                category: "기획",
                profileImage: "https://example.com/profile1.jpg",
                name: "김차돌",
                content: "첫 번째 플레이그라운드 뉴스의 내용입니다. 이것은 더미 데이터입니다.",
                isHotPost: true
            ),
            HomePresentationModel.PlaygroundNews(
                title: "두 번째 플레이그라운드 뉴스",
                category: "개발",
                profileImage: "https://example.com/profile2.jpg",
                name: "이개발",
                content: "두 번째 플레이그라운드 뉴스의 내용입니다. 이것도 더미 데이터입니다.",
                isHotPost: false
            ),
            HomePresentationModel.PlaygroundNews(
                title: "세 번째 플레이그라운드 뉴스",
                category: "디자인",
                profileImage: "https://example.com/profile3.jpg",
                name: "박디자인",
                content: "세 번째 플레이그라운드 뉴스의 내용입니다. 이것도 더미 데이터입니다.",
                isHotPost: true
            )
        ]
    }
    
    func createDummyRecentPosts() -> [HomePresentationModel.RecentPost] {
        return [
            HomePresentationModel.RecentPost(
                title: "첫 번째 최근 포스트",
                category: "기획",
                profileImage: "https://example.com/profile5.jpg",
                name: "정기획",
                content: "첫 번째 최근 포스트의 내용입니다. 이것은 더미 데이터입니다.",
                isHotPost: true
            ),
            HomePresentationModel.RecentPost(
                title: "두 번째 최근 포스트",
                category: "개발",
                profileImage: "https://example.com/profile6.jpg",
                name: "한개발",
                content: "두 번째 최근 포스트의 내용입니다. 이것도 더미 데이터입니다.",
                isHotPost: false
            ),
            HomePresentationModel.RecentPost(
                title: "세 번째 최근 포스트",
                category: "디자인",
                profileImage: "https://example.com/profile7.jpg",
                name: "윤디자인",
                content: "세 번째 최근 포스트의 내용입니다. 이것도 더미 데이터입니다.",
                isHotPost: true
            ),
            HomePresentationModel.RecentPost(
                title: "첫 번째 최근 포스트",
                category: "기획",
                profileImage: "https://example.com/profile5.jpg",
                name: "정기획",
                content: "첫 번째 최근 포스트의 내용입니다. 이것은 더미 데이터입니다.",
                isHotPost: true
            ),
            HomePresentationModel.RecentPost(
                title: "첫 번째 최근 포스트",
                category: "기획",
                profileImage: "https://example.com/profile5.jpg",
                name: "정기획",
                content: "첫 번째 최근 포스트의 내용입니다. 이것은 더미 데이터입니다.",
                isHotPost: true
            )
        ]
    }
}
