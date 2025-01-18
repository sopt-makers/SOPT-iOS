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
    let profileImageURL: String
    let userName: String
    let postTitle: String
    let isHotTag: Bool
}

struct GroupInfo {
    let title: String
    let category: GroupCategoryTagType
    let canJoinOnlyActiveGeneration: Bool
    let joinableParts: [String]
    let canJoinAllParts: Bool
    let status: RecruitmentStatusTagType
    let imageURL: String
}

struct CoffeeChatHostInfo {
    let memberId: Int
    let bio: String
    let topicTypeList: [String]
    let profileImage: String?
    let name: String
    let career: String?
    let organization: String
    let companyJob: String?
    let soptActivities: [String]
    let nowActivity: String?
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
    let insightInfoList: [InsightInfo] = [
        InsightInfo(category: "SOPT활동", profileImageURL: "https://img.seoul.co.kr/img/upload/2023/06/13/SSC_20230613163553_O2.png", userName: "차은우", postTitle: "차은우가 솝트 기획으로 활동한 썰 푼다 최대글자수입니다람지렁이", isHotTag: false)
    ]
    
    // TODO: 서버 연결 필요
    let groupInfoList: [GroupInfo] = [
        GroupInfo(title: "모임 타이틀이고 두 줄이 넘어가면 줄어들어야 합니다", category: .study, canJoinOnlyActiveGeneration: true, joinableParts: ["안드로이드", "서버", "iOS", "디자인"], canJoinAllParts: false, status: .applyAble, imageURL: "https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.JPG"),
        GroupInfo(title: "모임 타이틀이고 두 줄이 넘어가면 줄어들어야 합니다", category: .event, canJoinOnlyActiveGeneration: true, joinableParts: ["서버"], canJoinAllParts: false, status: .beforeStart, imageURL: "https://ojsfile.ohmynews.com/down/images/1/freesoul_76669_1[17].jpg"),
        GroupInfo(title: "모임 타이틀이고 두 줄이 넘어가면 줄어들어야 합니다", category: .study, canJoinOnlyActiveGeneration: true, joinableParts: ["안드로이드"], canJoinAllParts: false, status: .recruitmentComplete, imageURL: "https://www.petmove.co.kr/content/images/size/w2400/2023/09/ying-zhu-4UZfmxvc5Qk-unsplash.jpg"),
        GroupInfo(title: "모임 타이틀이고 두 줄이 넘어가면 줄어들어야 합니다", category: .event, canJoinOnlyActiveGeneration: true, joinableParts: ["iOS"], canJoinAllParts: false, status: .applyAble, imageURL: "https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.JPG"),
        GroupInfo(title: "모임 타이틀이고 두 줄이 넘어가면 줄어들어야 합니다", category: .study, canJoinOnlyActiveGeneration: true, joinableParts: ["iOS"], canJoinAllParts: false, status: .applyAble, imageURL: "https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.JPG")
    ]
    
    // TODO: 서버 연결 필요
    let coffeeChatHostInfoList: [CoffeeChatHostInfo] = [
        CoffeeChatHostInfo(memberId: 0, bio: "디자인 관련 고민이 있다면, 함께 나눠봐요!", topicTypeList: ["커리어", "면접", "포트폴리오"], profileImage: "https://i.pinimg.com/736x/d0/1e/78/d01e78f19a709a859f7c23d1cab11db3.jpg", name: "재영이", career: "주니어(0-3년차)", organization: "Google", companyJob: "Product Designer", soptActivities: ["29기 디자인"], nowActivity: "35기 웹"),
        CoffeeChatHostInfo(memberId: 0, bio: "디자인 관련 고민이 있다면, 함께 나눠봐요!", topicTypeList: ["커리어", "면접", "포트폴리오"], profileImage: "https://i.pinimg.com/736x/97/08/4c/97084c4f037ac2db897535268ca475b3.jpg", name: "포차코", career: "주니어(0-3년차)", organization: "Google", companyJob: "Product Designer", soptActivities: ["29기 디자인"], nowActivity: "35기 웹"),
        CoffeeChatHostInfo(memberId: 0, bio: "디자인 관련 고민이 있다면, 함께 나눠봐요!", topicTypeList: ["커리어", "면접", "포트폴리오"], profileImage: "https://i.pinimg.com/736x/d0/1e/78/d01e78f19a709a859f7c23d1cab11db3.jpg", name: "차은우", career: "주니어(0-3년차)", organization: "Google", companyJob: "Product Designer", soptActivities: ["29기 디자인"], nowActivity: "35기 웹")
    ]
    
    // TODO: 서버 연결 필요
    let announcementInfoList: [AnnouncementInfo] = [
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "사진이 있는 경우, 본문 내용은 한 줄로 보여주는 정책으로", images: "https://i.pinimg.com/736x/c5/e4/b7/c5e4b76374f640585796b8e01f907845.jpg"),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다 https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다", images: nil),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크  안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다", images: nil),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "사진이 있는 경우, 본문 내용은 한 줄로 보여주는 정책으로", images: "https://i.pinimg.com/736x/a8/c4/d2/a8c4d26e0dcedad1eacdcaf721a966b3.jpg"),
        AnnouncementInfo(id: 0, categoryName: "취업/진로", categoryDetailName: "꿀팁", title: "이력서를 쓰며 확인해야 할 7가지", profileImage: "https://i.pinimg.com/736x/5e/83/3a/5e833a2a1b804d3f0fdd0bae204c20f8.jpg", name: "눈멍이", content: "https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다 https://toss.im/career/job-detail?job_id=4071133003&company=토스뱅크 안녕하세요 31기 안드로이드 파트장 이현우입니다. 제가 속한 토스커뮤니티 계열사중 토스뱅크에서 네이티브 모바일 개발자를 채용을 시작했습니다.  토스커뮤니티에 관심있으신 분은 저에게 디스코드/링크드인 DM 주시면 감사하겠습니다", images: nil)
    ]
    
    let currentCardPage = PassthroughSubject<Int, Never>()
    
    // MARK: - Properties

    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
    
    var userType: UserType = UserDefaultKeyList.Auth.getUserType()
    var homeDescription: HomeDescriptionModel?
    var recentSchedule: HomeRecentScheduleModel?
    var appServices: [HomeAppServicesModel]?
    var insightPosts: [HomeInsightPostsModel]?
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let needToReload = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForMemberViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getHomeDescription()
                owner.useCase.getRecentSchedule()
                owner.useCase.getAppServices()
                owner.useCase.getInsightPosts()
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.homeDescription
            .withUnretained(self)
            .sink { owner, description in
                owner.homeDescription = description
                output.needToReload.send()
            }.store(in: cancelBag)
        
        useCase.recentSchedule
            .withUnretained(self)
            .sink { owner, schedule in
                owner.recentSchedule = schedule
                owner.recentSchedule?.date = setDateFormat(to: "MM.dd")
                output.needToReload.send()
            }.store(in: cancelBag)
        
        useCase.appServices
            .withUnretained(self)
            .sink { owner, services in
                owner.appServices = services
                output.needToReload.send()
            }.store(in: cancelBag)
        
        useCase.insightPosts
            .withUnretained(self)
            .sink { owner, posts in
                owner.insightPosts = posts
                output.needToReload.send()
            }.store(in: cancelBag)
    }
}
