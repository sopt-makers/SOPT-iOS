//
//  Publisher+UIControl.swift
//  Core
//
//  Created by Junho Lee on 2022/10/27.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

extension UIControl: CombineCompatible { }

public extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        return UIControlPublisher(control: self, events: events)
    }
}

final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

public struct UIControlPublisher<Control: UIControl>: Publisher {

    public typealias Output = Control
    public typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber,
                                                S.Failure == UIControlPublisher.Failure,
                                                S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}
