//
//  Publisher+WithLatestFrom.swift
//  Core
//
//  Created by 장석우 on 1/9/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    public struct WithLatestFrom<Upstream, Other> : Publisher where Upstream : Publisher, Other: Publisher,  Upstream.Failure == Other.Failure {

        public typealias Output = Other.Output
        public typealias Failure = Upstream.Failure

        public let upstream: Upstream
        public let other: Other
        
        public init(upstream: Upstream, other: Other) {
            self.upstream = upstream
            self.other = other
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Output == S.Input, Self.Failure == S.Failure {
            let merged = mergeStream(upstream, other)
            let result = resultStream(from: merged)
            result.subscribe(subscriber)
        }
    }
}

extension Publishers.WithLatestFrom {
    
    enum MergedOutput {
        case upstream(Upstream.Output)
        case other(Other.Output)
    }
    
    typealias ScanResult = (upstream: Upstream.Output?, other: Other.Output?, shouldEmit: Bool)
    
    func mergeStream(_ upstream: Upstream, _ other: Other) -> AnyPublisher<MergedOutput, Failure> {
        let upstream = upstream.map { MergedOutput.upstream($0)}
        let other = other.map { MergedOutput.other($0)}
        
        return upstream.merge(with: other).eraseToAnyPublisher()
    }
    
    func resultStream(from mergedStream: AnyPublisher<MergedOutput, Failure>) -> AnyPublisher<Output, Failure> {
        mergedStream
            .scan(nil) { result, mergedOutput -> ScanResult? in
                var upstream: Upstream.Output?
                var other: Other.Output?
                let shouldEmit: Bool
                
                switch mergedOutput {
                case let .upstream(output):
                    upstream = output
                    shouldEmit = result?.other != nil
                    
                case let .other(output):
                    other = output
                    shouldEmit = false
                }
                
                return ScanResult(
                    upstream: upstream ?? result?.upstream,
                    other: other ?? result?.other,
                    shouldEmit: shouldEmit
                )
            }
            .compactMap { $0 }
            .filter { $0.shouldEmit }
            .compactMap { $0.other }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    public func withLatestFrom<P>(_ other: P) -> Publishers.WithLatestFrom<Self, P> where P : Publisher, Self.Failure == P.Failure {
        return .init(upstream: self, other: other)
    }
}


