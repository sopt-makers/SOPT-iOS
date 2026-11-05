//
//  ScreenTracker.swift
//  SOPT-iOS-Demo
//
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

#if DEBUG
import UIKit
import ObjectiveC

import NectoModel
import NectoSDK

/// 현재 화면(가장 최근에 `viewDidAppear`된 ViewController)을 추적해서 Necto 패널로 보낸다.
final class ScreenTracker: @unchecked Sendable {
    static let shared = ScreenTracker()

    struct Record: Sendable {
        let id: Int
        let time: Date
        let name: String
        let module: String
        let title: String
        /// 바깥에서 안쪽 순서의 컨테이너 이름. 예: ["TabBarVC", "UINavigationController"]
        let path: [String]

        var json: NectoJSONValue {
            .object([
                "id": .number(Double(id)),
                "time": .string(Self.formatter.string(from: time)),
                "name": .string(name),
                "module": .string(module),
                "title": .string(title),
                "path": .array(path.map { .string($0) })
            ])
        }

        private static let formatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()
    }

    private static let capacity = 100

    private let lock = NSLock()
    private var history: [Record] = []
    private var nextID = 1
    private var subscribers: [UUID: AsyncStream<Record>.Continuation] = [:]

    func install() {
        _ = Self.swizzleOnce
    }

    func current() -> Record? {
        lock.withLock { history.last }
    }

    func snapshot() -> [Record] {
        lock.withLock { history }
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

    fileprivate func didAppear(_ viewController: UIViewController) {
        guard Self.isScreen(viewController) else { return }

        let (name, module) = Self.split(String(reflecting: type(of: viewController)))
        let path = Self.containers(of: viewController)

        let appended = lock.withLock { () -> (Record, [AsyncStream<Record>.Continuation])? in
            // 같은 화면이 연달아 appear되면(예: 모달을 닫고 돌아옴) 기록은 남기되 중복 연속은 건너뛴다.
            if let last = history.last, last.name == name, last.module == module { return nil }
            let record = Record(
                id: nextID,
                time: Date(),
                name: name,
                module: module,
                title: viewController.navigationItem.title ?? viewController.title ?? "",
                path: path
            )
            nextID += 1
            history.append(record)
            if history.count > Self.capacity { history.removeFirst(history.count - Self.capacity) }
            return (record, Array(subscribers.values))
        }

        guard let (record, continuations) = appended else { return }
        continuations.forEach { $0.yield(record) }
    }

    // MARK: - Helpers

    /// 컨테이너와 시스템 내부 VC는 화면으로 보지 않는다.
    private static func isScreen(_ viewController: UIViewController) -> Bool {
        if viewController is UINavigationController
            || viewController is UITabBarController
            || viewController is UIPageViewController
            || viewController is UISplitViewController {
            return false
        }
        let name = NSStringFromClass(type(of: viewController))
        // 모듈 접두사가 없는 UIKit 내부 클래스(UIInputWindowController, _UI... 등)
        return !(name.hasPrefix("UI") || name.hasPrefix("_UI") || name.hasPrefix("_"))
    }

    private static func split(_ reflected: String) -> (name: String, module: String) {
        let parts = reflected.split(separator: ".", maxSplits: 1).map(String.init)
        return parts.count == 2 ? (parts[1], parts[0]) : (reflected, "")
    }

    private static func containers(of viewController: UIViewController) -> [String] {
        var names: [String] = []
        var parent = viewController.parent
        while let current = parent {
            names.append(split(String(reflecting: type(of: current))).name)
            parent = current.parent
        }
        return names.reversed()
    }

    private static let swizzleOnce: Void = {
        guard
            let original = class_getInstanceMethod(
                UIViewController.self,
                #selector(UIViewController.viewDidAppear(_:))
            ),
            let injected = class_getInstanceMethod(
                UIViewController.self,
                #selector(UIViewController.necto_viewDidAppear(_:))
            )
        else { return }
        method_exchangeImplementations(original, injected)
    }()
}

private extension UIViewController {
    /// 구현이 교체된 뒤에는 `necto_viewDidAppear`가 원래의 `viewDidAppear`를 가리킨다.
    @objc func necto_viewDidAppear(_ animated: Bool) {
        necto_viewDidAppear(animated)
        ScreenTracker.shared.didAppear(self)
    }
}

// MARK: - Necto handlers

enum ScreenDebugHandlers {
    static func register(_ necto: NectoRegistrar) {
        necto.handle("screen.current") { _ in
            .object(["screen": ScreenTracker.shared.current()?.json ?? .null])
        }

        necto.handle("screen.history") { _ in
            .object(["screens": .array(ScreenTracker.shared.snapshot().map(\.json))])
        }

        necto.handle("screen.observe") { _, out in
            for await record in ScreenTracker.shared.stream() {
                await out.send(.object(["screen": record.json]))
            }
        }
    }
}
#endif
