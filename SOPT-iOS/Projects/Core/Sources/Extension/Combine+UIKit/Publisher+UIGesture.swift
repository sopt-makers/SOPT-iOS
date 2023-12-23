//
//  Publisher+UIGesture.swift
//  Core
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

public struct GesturePublisher: Publisher {
    public typealias Output = GestureType
    public typealias Failure = Never
    
    private let view: UIView
    private let gestureType: GestureType
    
    init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = GestureSubscription(
            subscriber: subscriber,
            view: self.view,
            gestureType: self.gestureType
        )
        subscriber.receive(subscription: subscription)
    }
}

final class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {
    private var subscriber: S?
    private var gestureType: GestureType
    private var view: UIView
    
    init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType
        self.configureGesture(gestureType)
    }
    
    private func configureGesture(_ gestureType: GestureType) {
        let gesture = gestureType.get()
        gesture.addTarget(self, action: #selector(self.handler))
        self.view.addGestureRecognizer(gesture)
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        self.subscriber = nil
    }
    
    @objc
    private func handler() {
        _ = self.subscriber?.receive(self.gestureType)
    }
}

public enum GestureType {
    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())
    case edge(UIScreenEdgePanGestureRecognizer = .init())
    
    public func get() -> UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture
        case let .swipe(swipeGesture):
            return swipeGesture
        case let .longPress(longPressGesture):
            return longPressGesture
        case let .pan(panGesture):
            return panGesture
        case let .pinch(pinchGesture):
            return pinchGesture
        case let .edge(edgePanGesture):
            return edgePanGesture
        }
    }
}

public extension UIView {
    func gesture(_ gestureType: GestureType = .tap()) -> GesturePublisher {
        self.isUserInteractionEnabled = true
        return GesturePublisher(view: self, gestureType: gestureType)
    }
}
