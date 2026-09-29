//
//  Demo.swift
//  AttendanceFeatureDemo
//
//  Created by 김영인 on 2023/04/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import BaseFeatureDependency

import AttendanceFeature
import AttendanceFeatureInterface

import Domain
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DIContainer.shared.register(
            interface: ShowAttendanceRepositoryInterface.self,
            implement: { StubShowAttendanceRepository() }
        )
        DIContainer.shared.register(
            interface: AttendanceRepositoryInterface.self,
            implement: { StubAttendanceRepository() }
        )

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application( _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let rootController = UINavigationController()

    lazy var attendanceCoordinator = AttendanceCoordinator(navigationController: rootController, factory: AttendanceBuilder())

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()

        attendanceCoordinator.start()
    }
}

// MARK: - Stub

/// 테스트할 일정 타입으로 변경
/// - hasAttendance: 출석 점수 반영되는 날
/// - noAttendance: 일정은 있지만 출석 점수 반영 안 되는 날
/// - noSession: 일정 없는 날
private let sessionType: SessionType = .noAttendance

struct StubShowAttendanceRepository: ShowAttendanceRepositoryInterface {
    func fetchAttendanceScheduleModel() -> AnyPublisher<AttendanceScheduleModel, Error> {
        let model: AttendanceScheduleModel
        switch sessionType {
        case .hasAttendance: model = scheduledDay
        case .noAttendance: model = noAttendanceDay
        case .noSession: model = unscheduledDay
        }
        return Just(model).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    private var unscheduledDay: AttendanceScheduleModel {
        AttendanceScheduleModel(
            type: SessionType.noSession.rawValue,
            id: 0,
            location: "",
            name: "",
            startDate: "",
            endDate: "",
            message: "",
            attendances: []
        )
    }
    
    private var noAttendanceDay: AttendanceScheduleModel {
        AttendanceScheduleModel(
            type: SessionType.noAttendance.rawValue,
            id: 1,
            location: "테스트 장소",
            name: "행사",
            startDate: "2026-10-03T14:00:00",
            endDate: "2026-10-03T18:00:00",
            message: I18N.Attendance.noAttendanceSession,
            attendances: []
        )
    }
    
    private var scheduledDay: AttendanceScheduleModel {
        AttendanceScheduleModel(
            type: SessionType.hasAttendance.rawValue,
            id: 1,
            location: "테스트 장소",
            name: "1차 세미나",
            startDate: "2026-10-03T14:00:00",
            endDate: "2026-10-03T18:00:00",
            message: "",
            attendances: [.init(status: "ATTENDANCE", attendedAt: "2026-10-03T14:10:00")]
        )
    }

    func fetchAttendanceScoreModel() -> AnyPublisher<AttendanceScoreModel, Error> {
        let model = AttendanceScoreModel(
            part: "iOS",
            generation: 37,
            name: "테스트",
            score: 1.5,
            total: TotalScoreModel(attendance: 1, absent: 1, tardy: 1, participate: 1),
            attendances: [
                .init(attribute: "SEMINAR", name: "1차 세미나", status: "ATTENDANCE", date: "10월 3일"),
                .init(attribute: "SEMINAR", name: "2차 세미나", status: "TARDY", date: "10월 10일"),
                .init(attribute: "SEMINAR", name: "3차 세미나", status: "ABSENT", date: "10월 17일"),
                .init(attribute: "EVENT", name: "행사", status: "PARTICIPATE", date: "10월 24일")
            ]
        )
        return Just(model).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func fetchLectureRound(lectureId: Int) -> AnyPublisher<AttendanceRoundModel?, Error> {
        Just(AttendanceRoundModel(subLectureId: 1, round: 2)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

/// 코드 "12345"만 성공, 나머지는 서버 에러 응답
struct StubAttendanceRepository: AttendanceRepositoryInterface {
    func postAttendance(lectureRoundId: Int, code: String) -> AnyPublisher<Bool, Error> {
        guard code == "12345" else {
            let json = #"{"success": false, "message": "[LectureException] : 코드가 일치하지 않아요"}"#
            let response = try! JSONDecoder().decode(OPErrorResponse.self, from: Data(json.utf8))
            return Fail(error: OPAPIError.attendanceError(response)).eraseToAnyPublisher()
        }
        return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
