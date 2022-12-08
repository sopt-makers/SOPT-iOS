//
//  KeyPathFindable.swift
//  Core
//
//  Created by Junho Lee on 2022/12/07.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

@dynamicMemberLookup
public struct KeyFinder<Base: AnyObject> {

    private var base: Base

    public init(_ base: Base) {
        self.base = base
    }

    public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>) -> ReferenceWritableKeyPath<Base, Value> {
        return keyPath
    }
}

public protocol KeyPathFindable {
    associatedtype Base: AnyObject
    var kf: KeyFinder<Base> { get }
}

public extension KeyPathFindable where Self: AnyObject {
    var kf: KeyFinder<Self> {
        get { KeyFinder(self) }
        set { }
    }
}

extension NSObject: KeyPathFindable { }
