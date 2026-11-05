//
//  AmplitudeEventRecorder.swift
//  SOPT-iOS-Demo
//
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

#if DEBUG
import Foundation

import NectoModel
import NectoSDK

/// Amplitude로 나가는 이벤트를 기록해서 Necto 패널로 보내기 위한 기록소.
///
/// 이벤트는 Core의 `AmplitudeInstance.onTrack` 훅으로 받는다.
/// Amplitude-Swift 플러그인으로는 받을 수 없다. Demo에도 SDK가 한 벌 더 링크되어
/// `AmplitudeInstance.shared`가 Demo가 만든 플러그인 타입을 인식하지 못하기 때문이다.
final class AmplitudeEventRecorder: @unchecked Sendable {
    static let shared = AmplitudeEventRecorder()

    struct Record: Sendable {
        let id: Int
        let time: Date
        let name: String
        let properties: String

        var json: NectoJSONValue {
            .object([
                "id": .number(Double(id)),
                "time": .string(Self.formatter.string(from: time)),
                "name": .string(name),
                "properties": .string(properties)
            ])
        }

        private static let formatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()
    }

    private static let capacity = 500

    private let lock = NSLock()
    private var records: [Record] = []
    private var nextID = 1
    private var subscribers: [UUID: AsyncStream<Record>.Continuation] = [:]

    func record(eventType: String, properties: [String: Any]?) {
        let (record, continuations) = lock.withLock { () -> (Record, [AsyncStream<Record>.Continuation]) in
            let record = Record(
                id: nextID,
                time: Date(),
                name: eventType,
                properties: Self.render(properties)
            )
            nextID += 1
            records.append(record)
            if records.count > Self.capacity { records.removeFirst(records.count - Self.capacity) }
            return (record, Array(subscribers.values))
        }
        continuations.forEach { $0.yield(record) }
    }

    func snapshot() -> [Record] {
        lock.withLock { records }
    }

    func clear() {
        lock.withLock { records.removeAll() }
    }

    func stream() -> AsyncStream<Record> {
        AsyncStream { continuation in
            let id = UUID()
            lock.withLock { subscribers[id] = continuation }
            continuation.onTermination = { [weak self] _ in
                self?.lock.withLock { _ = self?.subscribers.removeValue(forKey: id) }
            }
        }
    }

    private static func render(_ properties: [String: Any]?) -> String {
        guard let properties, !properties.isEmpty else { return "" }
        if
            JSONSerialization.isValidJSONObject(properties),
            let data = try? JSONSerialization.data(withJSONObject: properties, options: [.sortedKeys]),
            let text = String(data: data, encoding: .utf8)
        {
            return text
        }
        return String(describing: properties)
    }
}

// MARK: - Necto handlers

enum AmplitudeDebugHandlers {
    static func register(_ necto: NectoRegistrar) {
        necto.handle("amplitude.list") { _ in
            .object(["events": .array(AmplitudeEventRecorder.shared.snapshot().map(\.json))])
        }

        necto.handle("amplitude.observe") { _, out in
            for await record in AmplitudeEventRecorder.shared.stream() {
                await out.send(.object(["event": record.json]))
            }
        }

        necto.handle("amplitude.clear") { _ in
            AmplitudeEventRecorder.shared.clear()
            return .object(["ok": .bool(true)])
        }
    }
}
#endif
