//
//  MainUseCase.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Combine

public protocol MainUseCase {
  var userMainInfo: PassthroughSubject<UserMainInfoModel?, Never> { get set }
  var mainDescription: PassthroughSubject<MainDescriptionModel, Never> { get set }
  var mainErrorOccurred: PassthroughSubject<MainError, Never> { get set }
  var isPokeNewUser: PassthroughSubject<Bool, Never> { get set }
  var appService: PassthroughSubject<[AppServiceModel], Never> { get set }
  var hotBoard: PassthroughSubject<HotBoardModel, Never> { get set }

  func getUserMainInfo()
  func getMainViewDescription()
  func registerPushToken()
  func checkPokeNewUser()
  func getAppService()
  func getHotBoard()
  func getReportUrl()
}

public class DefaultMainUseCase {

  private let repository: MainRepositoryInterface
  private var cancelBag = CancelBag()

  public var userMainInfo = PassthroughSubject<UserMainInfoModel?, Never>()
  public var mainDescription = PassthroughSubject<MainDescriptionModel, Never>()
  public var mainErrorOccurred = PassthroughSubject<MainError, Never>()
  public var isPokeNewUser = PassthroughSubject<Bool, Never>()
  public var appService = PassthroughSubject<[AppServiceModel], Never>()
  public var hotBoard = PassthroughSubject<HotBoardModel, Never>()


  public init(repository: MainRepositoryInterface) {
    self.repository = repository
  }
}

extension DefaultMainUseCase: MainUseCase {
  public func getUserMainInfo() {
    repository.getUserMainInfo()
      .catch { [weak self] error in
        print("MainUseCase getUserMainInfo error occurred: \(error)")
        self?.mainErrorOccurred.send(error)
        return Just<UserMainInfoModel?>(nil).eraseToAnyPublisher()
      }
      .sink { [weak self] userMainInfoModel in
        self?.setUserType(with: userMainInfoModel?.userType)
        self?.userMainInfo.send(userMainInfoModel)
      }.store(in: self.cancelBag)
  }

  public func getMainViewDescription() {
    repository.getMainViewDescription()
      .replaceError(with: .defaultDescription)
      .withUnretained(self)
      .sink { owner, mainDescriptionModel in
          owner.mainDescription.send(mainDescriptionModel)
      }.store(in: self.cancelBag)
  }

  public func registerPushToken() {
    guard let pushToken = UserDefaultKeyList.User.pushToken, !pushToken.isEmpty else { return }

    repository.registerPushToken(with: pushToken)
      .sink { event in
        print("MainUseCase Register PushToken: \(event)")
      } receiveValue: { didSucceed in
        print("푸시 토큰 등록 결과: \(didSucceed)")
      }.store(in: cancelBag)
  }

  public func checkPokeNewUser() {
    repository.checkPokeNewUser()
      .catch { [weak self] error in
        print("MainUseCase CheckPokeNewUser Error: \(error)")
        self?.mainErrorOccurred.send(.networkError(message: "Poke 온보딩 대상 여부 확인 실패"))
        return Empty<Bool, Never>()
      }.sink { [weak self] isNewUser in
        self?.isPokeNewUser.send(isNewUser)
      }.store(in: cancelBag)
  }

  private func setUserType(with userType: UserType?) {
    switch userType {
    case .none, .inactive:
      UserDefaultKeyList.Auth.isActiveUser = false
    case .active:
      UserDefaultKeyList.Auth.isActiveUser = true
    default:
      UserDefaultKeyList.Auth.isActiveUser = false
    }
  }

  public func getAppService() {
    repository.appService()
      .catch { [weak self] error in
        print("MainUseCase getAppService Error: \(error)")
        self?.mainErrorOccurred.send(.networkError(message: "앱 서비스 확인 실패"))
        return Just<[AppServiceModel]>.empty()
      }
      .sink { [weak self] services in
        self?.appService.send(services)
      }
      .store(in: cancelBag)
  }

  public func getHotBoard() {
    repository.hotBoard()
      .catch { [weak self] error in
        print("MainUseCase hotBoard Error: \(error)")
        self?.mainErrorOccurred.send(.networkError(message: "앱 서비스 확인 실패"))
        return Just<HotBoardModel>.empty()
      }
      .sink { [weak self] hotBoard in
        self?.hotBoard.send(hotBoard)
      }
      .store(in: cancelBag)
  }
    
  public func getReportUrl() {
    repository.getReportUrl()
      .withUnretained(self)
      .sink { event in
          print("GetReportUrl State: \(event)")
      } receiveValue: { owner, resultModel in
          UserDefaultKeyList.Soptamp.reportUrl = resultModel.reportUrl
      }.store(in: cancelBag)
  }
}
