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
    let category: GroupCategoryType
    let canJoinOnlyActiveGeneration: Bool
    let joinableParts: [String]
    let canJoinAllParts: Bool
    let status: RecruitmentStatusType
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

@frozen
enum GroupCategoryType: String {
    case event = "EVENT"
    case study = "STUDY"
    
    var text: String {
        switch self {
        case .event:
            return "행사"
        case .study:
            return "스터디"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .event:
            return DSKitAsset.Colors.success.color
        case .study:
            return DSKitAsset.Colors.secondary.color
        }
    }
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
        AppServiceInfo(name: "콕찌르기", imageURL: "https://images.mypetlife.co.kr/content/uploads/2018/12/09154907/cotton-tulear-2422612_1280.jpg", badgeText: "3"),
        AppServiceInfo(name: "솝마디", imageURL: "https://images.mypetlife.co.kr/content/uploads/2018/12/09154907/cotton-tulear-2422612_1280.jpg", badgeText: "N"),
        AppServiceInfo(name: "솝탬프", imageURL: "https://images.mypetlife.co.kr/content/uploads/2018/12/09154907/cotton-tulear-2422612_1280.jpg", badgeText: "3위")
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
