//
//  LinkDebugHandlers.swift
//  SOPT-iOS-Demo
//
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

#if DEBUG
import UIKit
import UserNotifications

import NectoModel
import NectoSDK
import RootFeature

/// 푸시 알림과 딥링크를 앱 안에서 직접 흉내 내는 핸들러.
///
/// - `push.send`: apns 파일을 시뮬레이터에 끌어넣는 대신, 같은 `userInfo`를 담은 로컬 알림을 예약한다.
///   `UNUserNotificationCenter`의 델리게이트가 `NotificationHandler`라서 `willPresent`와 `didReceive`를
///   실제 푸시와 같은 경로로 탄다. 사일런트 푸시처럼 APNs 전달 자체가 필요한 건 재현하지 못한다.
/// - `link.deeplink` / `link.weblink`: 알림을 거치지 않고 `NotificationHandler`의 링크 처리만 바로 호출한다.
enum LinkDebugHandlers {
    static func register(_ necto: NectoRegistrar) {
        necto.handle("link.deeplink") { input in
            let deepLink = try requiredString("deepLink", in: input)
            try await openLink { $0.receive(deepLink: deepLink) }
            return .object(["ok": .bool(true)])
        }

        necto.handle("link.weblink") { input in
            let webLink = try requiredString("webLink", in: input)
            try await openLink { $0.receive(webLink: webLink) }
            return .object(["ok": .bool(true)])
        }

        necto.handle("push.send") { input in
            let title = try requiredString("title", in: input)
            let body = try requiredString("body", in: input)
            let id = try requiredString("id", in: input)
            let delay = max(1, optionalNumber("delaySeconds", in: input) ?? 1)

            // `NotificationPayload`가 읽는 형태(aps.alert.title/body, id, category, deepLink, webLink)로 만든다.
            var userInfo: [String: Any] = [
                "aps": ["alert": ["title": title, "body": body]],
                "id": id
            ]
            for key in ["category", "deepLink", "webLink"] {
                if let value = optionalString(key, in: input), !value.isEmpty { userInfo[key] = value }
            }

            try await schedule(title: title, body: body, userInfo: userInfo, delay: delay)
            return .object(["ok": .bool(true), "delaySeconds": .number(delay)])
        }
    }

    // MARK: - Actions

    private static func openLink(_ action: @escaping @MainActor (NotificationHandler) -> Void) async throws {
        try await MainActor.run {
            guard let handler = currentNotificationHandler() else { throw DebugError.notReady }
            action(handler)
        }
    }

    private static func schedule(title: String, body: String, userInfo: [String: Any], delay: Double) async throws {
        let center = UNUserNotificationCenter.current()

        var settings = await center.notificationSettings()
        if settings.authorizationStatus == .notDetermined {
            _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
            settings = await center.notificationSettings()
        }
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            throw DebugError.notAuthorized
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo

        let request = UNNotificationRequest(
            identifier: "sopt-debug.\(UUID().uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        )
        try await center.add(request)
    }

    // MARK: - Helpers

    /// Demo의 `SceneDelegate`가 들고 있는 핸들러. `ApplicationCoordinator`가 쓰는 것과 같은 인스턴스다.
    @MainActor
    private static func currentNotificationHandler() -> NotificationHandler? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0.delegate as? SceneDelegate)?.notificationHandler }
            .first
    }

    private static func requiredString(_ key: String, in input: NectoJSONValue) throws -> String {
        guard let value = optionalString(key, in: input), !value.isEmpty else { throw DebugError.missing(key) }
        return value
    }

    private static func optionalString(_ key: String, in input: NectoJSONValue) -> String? {
        guard case .object(let fields) = input, case .string(let value)? = fields[key] else { return nil }
        return value
    }

    private static func optionalNumber(_ key: String, in input: NectoJSONValue) -> Double? {
        guard case .object(let fields) = input, case .number(let value)? = fields[key] else { return nil }
        return value
    }

    private enum DebugError: LocalizedError {
        case missing(String)
        case notReady
        case notAuthorized

        var errorDescription: String? {
            switch self {
            case .missing(let key): return "\(key) 값이 필요해요"
            case .notReady: return "아직 앱의 알림 핸들러가 준비되지 않았어요"
            case .notAuthorized: return "알림 권한이 꺼져 있어요. 설정 앱에서 허용해 주세요"
            }
        }
    }
}
#endif
