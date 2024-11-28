//
//  HomeForMemberViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import UIKit
import Combine

import Core
import Domain
import DSKit

import HomeFeatureInterface
import BaseFeatureDependency

struct ProductInfo {
    let name: String
    let image: UIImage
}

struct AppServiceInfo {
    let name: String
    let imageURL: String
    let badgeText: String
}

struct InsightInfo {
    let category: String
    let profileImageURL: UIImage
    let userName: String
    let postTitle: String
    let isHotTag: Bool
}

struct AnnouncementInfo {
    let id: Int
    let categoryName: String
    let categoryDetailName: String
    let title: String
    let profileImage: String
    let name: String
    let content: String
    let images: String?
}

public class HomeForMemberViewModel: HomeForMemberViewModelType {
    
    // MARK: - Properties
    
    let productInfoList: [ProductInfo] = [
        ProductInfo(name: I18N.Home.MainProduct.playground, image: DSKitAsset.Assets.imgPlaygroundLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.groupAndStudy, image: DSKitAsset.Assets.imgGroupLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.member, image: DSKitAsset.Assets.imgMemberLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgProjectLogo.image)
    ]
    
    // TODO: 서버 연결 필요
    let appServiceInfoList: [AppServiceInfo] = [
        AppServiceInfo(name: "콕찌르기", imageURL: "", badgeText: "3"),
        AppServiceInfo(name: "솝마디", imageURL: "", badgeText: "N"),
        AppServiceInfo(name: "솝탬프", imageURL: "", badgeText: "3위")
    ]
    
    // TODO: 서버 연결 필요
    let insightInfoList: [InsightInfo] = [
        InsightInfo(category: "SOPT활동", profileImageURL: DSKitAsset.Assets.imgMemberLogo.image, userName: "차은우", postTitle: "차은우가 솝트 기획으로 활동한 썰 푼다 최대글자수입니다람지렁이", isHotTag: false)
    ]
    
    // TODO: 서버 연결 필요
    let announcementInfoList: [AnnouncementInfo] = [
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "사진이 있는 경우, 본문 내용은 한 줄로 보여주는 정책으로", images: "https://i.pinimg.com/736x/c5/e4/b7/c5e4b76374f640585796b8e01f907845.jpg"),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다 https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다", images: nil),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크  안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다", images: nil),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "사진이 있는 경우, 본문 내용은 한 줄로 보여주는 정책으로", images: "https://i.pinimg.com/736x/a8/c4/d2/a8c4d26e0dcedad1eacdcaf721a966b3.jpg"),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다 https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다", images: nil)
    ]
    
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - initialization
    
    public init() { }
}

extension HomeForMemberViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        return output
    }
}
