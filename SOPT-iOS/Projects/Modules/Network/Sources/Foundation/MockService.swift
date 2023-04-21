//
//  MockService.swift
//  Network
//
//  Created by 김영인 on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public class MockService<Target: TargetType> {
    
    typealias API = Target
    
    // MARK: - Init
    
    public init() {}
}

extension MockService {
    func requestObjectInCombine<T: Decodable>(_ target: API) -> AnyPublisher<T, Error> {
        return Future { promise in
            do {
                let decoder = JSONDecoder()
                let body = try decoder.decode(T.self, from: target.sampleData)
                promise(.success(body))
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
