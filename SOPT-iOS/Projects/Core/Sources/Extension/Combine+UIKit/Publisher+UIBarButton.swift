//
//  Publisher+UIBarButton.swift
//  Core
//
//  Created by Ian on 4/4/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

public extension UIBarButtonItem {
  final class Subscription<SubscriberType: Subscriber, Input: UIBarButtonItem>: Combine.Subscription where SubscriberType.Input == Input {
    private var subscriber: SubscriberType?
    private let input: Input
    
    // MARK: - Initialization
    
    public init(subscriber: SubscriberType, input: Input) {
      self.subscriber = subscriber
      self.input = input
      
      input.target = self
      input.action = #selector(eventHandler)
    }
    
    // MARK: - Subscriber
    
    // Do nothing as we only want to send events when they occur
    public func request(_ demand: Subscribers.Demand) {}
    
    // MARK: - Cancellable
    
    public func cancel() {
      subscriber = nil
    }
    
    // MARK: - Internal Functions
    
    @objc private func eventHandler() {
      _ = subscriber?.receive(input)
    }
  }
  
  // MARK: -
  
  struct Publisher<Output: UIBarButtonItem>: Combine.Publisher {
    public typealias Output = Output
    public typealias Failure = Never
    
    let output: Output
    
    // MARK: - Initialization
    
    public init(output: Output) {
      self.output = output
    }
    
    // MARK: - Publisher
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Output == S.Input {
      let subscription: Subscription = Subscription(subscriber: subscriber, input: output)
      subscriber.receive(subscription: subscription)
    }
  }
}

// MARK: - CombineCompatible

extension UIBarButtonItem: CombineCompatible {}

extension CombineCompatible where Self: UIBarButtonItem {
  public var tapPublisher: UIBarButtonItem.Publisher<Self> {
    return UIBarButtonItem.Publisher(output: self)
  }
}



import Combine
import UIKit

extension UIControl {
  func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
    return UIControl.EventPublisher(control: self, event: event)
  }
  
  struct EventPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    
    let control: UIControl
    let event: UIControl.Event
    
    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
      subscriber.receive(subscription: subscription)
    }
  }
  
  fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
    let control: UIControl
    let event: UIControl.Event
    var subscriber: EventSubscriber?
    
    init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
      self.control = control
      self.subscriber = subscrier
      self.event = event
      
      control.addTarget(self, action: #selector(eventDidOccur), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
      subscriber = nil
      control.removeTarget(self, action: #selector(eventDidOccur), for: event)
    }
    
    @objc func eventDidOccur() {
      _ = subscriber?.receive(control)
    }
  }
}
