//
//  SOPTDebugPlugin.swift
//  SOPT-iOS-Demo
//
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

#if DEBUG
import Foundation

import NectoModel
import NectoSDK

/// Demo 앱 전용 Necto 디바이스 플러그인.
/// 패널은 `Projects/Demo/NectoPanelSource`에서 빌드해 `Projects/Demo/NectoPanel`에 둔다.
struct SOPTDebugPlugin: NectoPlugin {
    let id = "sopt-debug"

    var panel: NectoPluginPanel? {
        NectoPluginPanel(bundle: .main, subdirectory: "NectoPanel")
    }

    func register(_ necto: NectoRegistrar) {
        UserDefaultsDebugHandlers.register(necto)
        AmplitudeDebugHandlers.register(necto)
        ScreenDebugHandlers.register(necto)
        LinkDebugHandlers.register(necto)
    }
}

// MARK: - UserDefaults

private enum UserDefaultsDebugHandlers {
    /// 값이 없어도 목록에 항상 보여줄 키. 최초 진입 플로우 재현에 쓰는 플래그들이다.
    /// 키 문자열은 `UserDefaultKeyList`(Core)의 `@UserDefaultWrapper(key:)`와 같아야 한다.
    static let pinnedKeys = [
        "isFirstVisitToPokeView",
        "isVisitedPokeMainView",
        "isCompleteSoptletterOnboarding",
        "isActiveUser",
        "isAppjam",
        "checkedAppVersion"
    ]

    static func register(_ necto: NectoRegistrar) {
        necto.handle("userdefaults.list") { _ in
            .object(["entries": .array(entries())])
        }

        necto.handle("userdefaults.set") { input in
            guard
                case .object(let fields) = input,
                case .string(let key)? = fields["key"],
                case .string(let type)? = fields["type"],
                case .string(let raw)? = fields["value"]
            else { throw DebugError.invalidInput }

            switch type {
            case "bool":
                guard let value = parseBool(raw) else { throw DebugError.invalidValue("bool은 true/false 중 하나여야 해요") }
                UserDefaults.standard.set(value, forKey: key)
            case "number":
                guard let value = Double(raw) else { throw DebugError.invalidValue("숫자로 변환할 수 없어요") }
                UserDefaults.standard.set(value, forKey: key)
            default:
                UserDefaults.standard.set(raw, forKey: key)
            }
            return .object(["ok": .bool(true)])
        }

        necto.handle("userdefaults.remove") { input in
            guard case .object(let fields) = input, case .string(let key)? = fields["key"] else {
                throw DebugError.invalidInput
            }
            UserDefaults.standard.removeObject(forKey: key)
            return .object(["ok": .bool(true)])
        }
    }

    private static func entries() -> [NectoJSONValue] {
        // `dictionaryRepresentation()`은 시스템이 넣은 키(Apple*, AK* 등)까지 섞여 나온다.
        // 앱 도메인에는 앱이 직접 쓴 값만 들어 있어서 그쪽을 읽는다.
        let appDomain = Bundle.main.bundleIdentifier.flatMap { UserDefaults.standard.persistentDomain(forName: $0) } ?? [:]
        let keys = Set(appDomain.keys).union(pinnedKeys)

        return keys.sorted().map { key in
            let value = UserDefaults.standard.object(forKey: key)
            let (type, text) = describe(value)
            return .object([
                "key": .string(key),
                "type": .string(type),
                "value": .string(text),
                "exists": .bool(value != nil)
            ])
        }
    }

    private static func describe(_ value: Any?) -> (type: String, text: String) {
        switch value {
        case nil:
            return ("none", "")
        case let number as NSNumber:
            // NSNumber는 Bool과 숫자를 구분하지 못해서 CFBoolean 여부로 판별한다.
            if CFGetTypeID(number) == CFBooleanGetTypeID() {
                return ("bool", number.boolValue ? "true" : "false")
            }
            return ("number", number.stringValue)
        case let string as String:
            return ("string", string)
        case let value?:
            return ("other", String(describing: value))
        }
    }

    private static func parseBool(_ raw: String) -> Bool? {
        switch raw.lowercased() {
        case "true", "1", "yes": return true
        case "false", "0", "no": return false
        default: return nil
        }
    }

    private enum DebugError: LocalizedError {
        case invalidInput
        case invalidValue(String)

        var errorDescription: String? {
            switch self {
            case .invalidInput: return "잘못된 입력이에요"
            case .invalidValue(let message): return message
            }
        }
    }
}
#endif
