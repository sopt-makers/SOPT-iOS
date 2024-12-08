//
//  SoptlogViewModel.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import HomeFeatureInterface
import BaseFeatureDependency

struct ProfileInfo {
    let profileImageURL: String
    let name: String
    let part: String
    let introduce: String
}

struct AppServiceInfo {
    let serviceName: String
    let serviceImageURL: String
    let serviceValue: String
}

struct SoptlogAlarmInfo {
    let imageURL: String
    let title: String
    let subTitle: String
}

public class SoptlogViewModel: SoptlogViewModelType {
    
    let profileInfoList: [ProfileInfo] = [
        ProfileInfo(
            profileImageURL: "https://i1.sndcdn.com/artworks-000660272461-rmfvxq-t500x500.jpg",
            name: "짱구씨",
            part: "iOS/디자인/기획/안드로이드/웹/서버",
            introduce: "한줄소개는 공백포함 최대15"
        )
    ]
    
    let appServiceInfoList: [AppServiceInfo] = [
        AppServiceInfo(
            serviceName: "솝레벨",
            serviceImageURL: "https://i.pinimg.com/originals/99/7a/9b/997a9b2cd93277769ca9b3d109bceed7.jpg",
            serviceValue: "Lv.6"),
        AppServiceInfo(
            serviceName: "콕찌르기",
            serviceImageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5_o58idJtowURqF99s9mM1pC76aIf9t1K7w&s",
            serviceValue: "208회"),
        AppServiceInfo(
            serviceName: "솝탬프",
            serviceImageURL: "https://i.pinimg.com/736x/7d/9d/e4/7d9de429c35854f0ec32d8e0704a7d63.jpg",
            serviceValue: "14등"),
    ]
    
    let soptlogAlarmInfoList: [SoptlogAlarmInfo] = [
        SoptlogAlarmInfo(
            imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcvCXwH8rPUMVwEnu5ADHwOSdwGZcqdzotiQ&s",
            title: "짱구님, 잊지 말아야 할 말들을 듣게 될 거예요",
            subTitle: "바로 확인하기")
    ]
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - initialization
    
    public init() { }
}

extension SoptlogViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        return output
    }
}

