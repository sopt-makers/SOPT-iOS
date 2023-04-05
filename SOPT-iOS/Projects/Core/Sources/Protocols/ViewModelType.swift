//
//  ViewModelType.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Combine

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output
}
