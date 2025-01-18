//
//  HomeCalendarDetailViewModel.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import HomeFeatureInterface

struct CalendarDetail {
    let date: String
    let title: String
    let isRecentSchedule: Bool
    let type: DashBoardCalenderCategoryTagType
}


public class HomeCalendarDetailViewModel: HomeCalendarDetailViewModelType {
    
    // TODO: - 서버 연결 필요
    
    let calendarDetailList: [CalendarDetail] = [
        CalendarDetail(date: "9월 28일 토요일", title: "OT", isRecentSchedule: false, type: .event),
        CalendarDetail(date: "9월 28일 토요일", title: "1차 세미나", isRecentSchedule: false, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "2차 세미나", isRecentSchedule: false, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "3차 세미나", isRecentSchedule: true, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "4차 세미나", isRecentSchedule: false, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "5차 세미나", isRecentSchedule: false, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "6차 세미나", isRecentSchedule: false, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "7차 세미나", isRecentSchedule: false, type: .seminar),
        CalendarDetail(date: "9월 28일 토요일", title: "8차 세미나", isRecentSchedule: false, type: .seminar)
    ]
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - initialization
    
    public init() { }
}

extension HomeCalendarDetailViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        return output
    }
}
