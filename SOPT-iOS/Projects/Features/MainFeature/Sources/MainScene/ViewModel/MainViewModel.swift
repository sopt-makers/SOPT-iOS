//
//  MainViewModel.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine
import UserNotifications

import Core
import Domain
import MainFeatureInterface

import Sentry

public class MainViewModel: MainViewModelType {
  // MARK: - Properties

  private let useCase: MainUseCase
  private var cancelBag = CancelBag()

  var userType: UserType = .visitor
  var mainHeaderViewType: MainHeaderViewType = .defaultMainServiceHeaderView
  var mainServiceList: [ServiceType] = [.officialHomepage, .review, .project]
  var otherServiceList: [ServiceType] = [.instagram, .youtube, .faq]
  var appServiceList: [AppServiceType] = []
  var userMainInfo: UserMainInfoModel?
  var mainDescription: MainDescriptionModel = .defaultDescription
  var hotBoard: HotBoardModel?

  // MARK: - Inputs

  public struct Input {
    let requestUserInfo: Driver<Void>
    let viewDidLoad: Driver<Void>
    let noticeButtonTapped: Driver<Void>
    let myPageButtonTapped: Driver<Void>
    let cellTapped: Driver<IndexPath>
    let hotBoardTapped: Driver<HotBoardModel>
  }

  // MARK: - Outputs

  public struct Output {
    var needToReload = PassthroughSubject<Void, Never>()
    var isServiceAvailable = PassthroughSubject<Bool, Never>()
    var needNetworkAlert = PassthroughSubject<Void, Never>()
    var isLoading = PassthroughSubject<Bool, Never>()
  }

  // MARK: - MainCoordinatable

  public var onNoticeButtonTap: (() -> Void)?
  public var onMyPageButtonTap: ((UserType) -> Void)?
  public var onSafari: ((String) -> Void)?
  public var onAttendance: (() -> Void)?
  public var onSoptamp: (() -> Void)?
  public var onPoke: ((_ isFirstVisit: Bool) -> Void)?
  public var onNeedSignIn: (() -> Void)?

  // MARK: - init

  public init(useCase: MainUseCase, userType: UserType) {
    self.useCase = useCase
    self.userType = userType
    setServiceList(with: userType)
  }
}

// MARK: - Methods

extension MainViewModel {
  public func transform(from input: Input, cancelBag: CancelBag) -> Output {
    let output = Output()
    self.bindOutput(output: output, cancelBag: cancelBag)

    input.noticeButtonTapped
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.onNoticeButtonTap?()
        self.trackAmplitude(event: .clickAlarm)
      }.store(in: cancelBag)

    input.myPageButtonTapped
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.onMyPageButtonTap?(self.userType)
        self.trackAmplitude(event: .clickMyPage)
      }.store(in: cancelBag)

    input.cellTapped
      .filter { $0.section == 1 }
      .map { $0.item }
      .compactMap { [weak self] index in
        self?.mainServiceList[index]
      }.sink { [weak self] service in
        self?.handleMainServiceSectionTap(with: service)
      }.store(in: cancelBag)

    input.cellTapped
      .filter { $0.section == 2 }
      .map { $0.item }
      .compactMap { [weak self] index in
        self?.otherServiceList[index]
      }.sink { [weak self] service in
        self?.handleOtherServiceSectionTap(with: service)
      }.store(in: cancelBag)

    let appServiceSectionService = input.cellTapped
      .filter { [weak self] _ in
        guard let self else { return false }
        return self.userType != .visitor
      }
      .filter { $0.section == 3 }
      .map { $0.item }
      .compactMap { [weak self] index in
        return self?.appServiceList[index]
      }.eraseToAnyPublisher()

    appServiceSectionService.sink { [weak self] service in
      self?.trackAmplitude(event: service.toAmplitudeEventType)
    }.store(in: cancelBag)

    appServiceSectionService.filter { $0 == .soptamp }
      .sink { [weak self] _ in
        self?.onSoptamp?()
      }.store(in: cancelBag)

    appServiceSectionService.filter { $0 == .poke }
      .sink { [weak self] _ in
        output.isLoading.send(true)
        self?.useCase.checkPokeNewUser()
      }.store(in: cancelBag)

    input.requestUserInfo
      .sink { [weak self] _ in
        guard let self = self else { return }
        if self.userType != .visitor {
          output.isLoading.send(true)
          self.useCase.getUserMainInfo()
          self.useCase.getMainViewDescription()
          self.useCase.getHotBoard()
        }
      }.store(in: cancelBag)

    input.viewDidLoad
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.requestAuthorizationForNotification()
        self.useCase.getServiceState()
        self.trackAmplitude(event: .viewAppHome)
      }.store(in: cancelBag)

    input.hotBoardTapped
      .map { $0.url }
      .sink { [weak self] url in
        self?.trackAmplitude(event: .clickHotboard)
        self?.onSafari?(url)
      }.store(in: cancelBag)

    return output
  }

  private func bindOutput(output: Output, cancelBag: CancelBag) {
    useCase.userMainInfo
      .sink { [weak self] userMainInfo in
        guard let self = self else { return }
        guard let userMainInfo = userMainInfo else {
          SentrySDK.capture(message: "메인 뷰 조회 실패")
          return
        }
        self.userMainInfo = userMainInfo
        self.userType = userMainInfo.userType
        self.setServiceList(with: self.userType)
        self.setSentryUser()
        self.useCase.getAppService()
        output.needToReload.send()
      }.store(in: self.cancelBag)

    useCase.serviceState
      .sink { serviceState in
        output.isServiceAvailable.send(serviceState.isAvailable)
      }.store(in: self.cancelBag)

    useCase.mainDescription
      .sink { [weak self] mainDescription in
        self?.mainDescription = mainDescription
        output.needToReload.send()
      }.store(in: self.cancelBag)

    useCase.hotBoard
      .sink { [weak self] hotBoard in
        self?.hotBoard = hotBoard
        output.needToReload.send()
      }.store(in: self.cancelBag)

    // 필수 API 통신 완료되면 로딩뷰 숨기기
    Publishers.Zip3(
      useCase.userMainInfo,
      useCase.appService,
      useCase.hotBoard
    )
    .sink { _ in
      output.isLoading.send(false)
    }.store(in: self.cancelBag)

    useCase.mainErrorOccurred
      .sink { [weak self] error in
        guard let self else { return }
        output.isLoading.send(false)
        SentrySDK.capture(error: error)
        switch error {
        case .networkError:
          output.needNetworkAlert.send()
        case .authFailed:
          self.onNeedSignIn?()
        }
      }.store(in: self.cancelBag)

    useCase.isPokeNewUser
      .sink { [weak self] isNewUser in
        output.isLoading.send(false)
        self?.onPoke?(isNewUser)
      }.store(in: cancelBag)

    useCase.appService
      .sink { [weak self] serviceModels in
        self?.updateAppServices(with: serviceModels)
        output.needToReload.send()
      }.store(in: cancelBag)
  }

  private func handleMainServiceSectionTap(with service: ServiceType) {
    self.trackAmplitude(event: service.toAmplitudeEventType)

    guard service != .attendance else {
      onAttendance?()
      return
    }

    let needOfficialProject = service == .project && userType == .visitor
    let serviceDomainURL = needOfficialProject
    ? ExternalURL.SOPT.project
    : service.serviceDomainLink
    onSafari?(serviceDomainURL)
  }

  private func handleOtherServiceSectionTap(with service: ServiceType) {
    self.trackAmplitude(event: service.toAmplitudeEventType)

    onSafari?(service.serviceDomainLink)
  }

  private func requestAuthorizationForNotification() {
    guard self.userType != .visitor,
          UserDefaultKeyList.Auth.hasAccessToken(),
          UserDefaultKeyList.User.hasPushToken()
    else { return }

    // APNS 권한 허용 확인
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      if let error = error { print(error) }
      AmplitudeInstance.shared.addPushNotificationAuthorizationIdentity(isAuthorized: granted)
      print("APNs-알림 권한 허용 유무 \(granted)")

      if granted {
        self.useCase.registerPushToken()
      }
    }
  }

  /// 메인 뷰에 보여줄 카드들 종류 설정
  private func setServiceList(with userType: UserType) {
    switch userType {
    case .visitor:
      self.mainServiceList = [.officialHomepage, .review, .project]
      self.otherServiceList = [.instagram, .youtube, .faq]
      self.appServiceList = [.poke, .soptamp]
      self.mainHeaderViewType = .defaultMainServiceHeaderView
    case .active:
      self.mainServiceList = [.attendance, .group, .playgroundCommunity]
      self.otherServiceList = [.member, .project, .officialHomepage]
      self.mainHeaderViewType = .hotBoard
    case .inactive:
      self.mainServiceList = [.playgroundCommunity, .group, .member]
      self.otherServiceList = [.project, .officialHomepage, .instagram, .youtube]
      self.mainHeaderViewType = .hotBoard
    }
  }

  private func updateAppServices(with services: [AppServiceModel]) {
    appServiceList.removeAll()
    for service in services {
      guard let appServiceType = AppServiceType(rawValue: service.serviceName) else {
        continue
      }

      if appServiceType.isHeaderService {
        if appServiceType == .hotboard && checkServiceCanShowForUserType(service: service) {
          mainHeaderViewType = .hotBoard
        } else {
          mainHeaderViewType = .defaultMainServiceHeaderView
        }
        continue
      }

      if checkServiceCanShowForUserType(service: service) {
        appServiceList.append(appServiceType)
      }
    }
  }

  private func checkServiceCanShowForUserType(service: AppServiceModel) -> Bool {
    if userType == .active && service.activeUser {
      return true
    }

    if userType == .inactive && service.inactiveUser {
      return true
    }

    return false
  }

  /// 최초 솝트 가입일로부터 몇달이 지났는지 계산
  func calculateMonths() -> String? {
    guard let userMainInfo = userMainInfo, let firstHistory = userMainInfo.historyList.last else { return nil }
    guard let joinDate = calculateJoinDateWithFirstHistory(history: firstHistory), let monthDifference = calculateMonthDifference(since: joinDate) else { return nil }

    return String(monthDifference)
  }

  // 파라미터로 넣은 기수의 시작 날짜를 리턴
  private func calculateJoinDateWithFirstHistory(history: Int) -> Date? {
    let yearDifference = history / 2
    let month = (history % 2 == 0) ? 3 : 9 // 짝수 기수는 3월, 홀수 기수는 9월 시작
    // 1기를 2007년으로 계산
    return Date.from(year: yearDifference + 2007, month: month, day: 1)
  }

  // 파라미터로 넣은 날짜로 부터 현재 몇달이 지났는지 계산
  private func calculateMonthDifference(since startDate: Date) -> Int? {
    let calendar = Calendar.current

    let components = calendar.dateComponents([.month], from: startDate, to: .now)
    guard let month = components.month else {
      return nil
    }

    return month >= 0 ? month + 1 : nil
  }
}

extension MainViewModel {
  private func setSentryUser() {
    let user = User(
      userId: "\(self.userType.rawValue)_\(userMainInfo?.name ?? "비회원")"
    )
    user.data = ["accessToken": UserDefaultKeyList.Auth.appAccessToken ?? "EmptyAppAccessToken"]
    SentrySDK.setUser(user)
  }

  private func trackAmplitude(event: AmplitudeEventType) {
    AmplitudeInstance.shared.trackWithUserType(event: event)
  }
}
