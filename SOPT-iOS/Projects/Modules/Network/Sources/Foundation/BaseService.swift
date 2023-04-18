//
//  BaseService.swift
//  Network
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import Foundation

import Core

import Alamofire
import Moya


public enum SOPTAPPError: Error {
    case network(statusCode: Int)
    case unknown
    
    init(error: Error, statusCode: Int? = 0) {
        guard let statusCode else { self = .unknown ; return }
        
        self = .network(statusCode: statusCode)
    }
}


open class BaseService<Target: TargetType> {
    
    typealias API = Target
    
    // MARK: - Properties
    
    var cancelBag = CancelBag()
    
    lazy var provider = self.defaultProvider
    
    private lazy var defaultProvider: MoyaProvider<API> = {
        let provider = MoyaProvider<API>(
            endpointClosure: endpointClosure,
            session: DefaultAlamofireManager.shared,
            plugins: [NetworkLoggerPlugin(verbose: true)]
        )
        return provider
    }()
    
    private lazy var testingProvider: MoyaProvider<API> = {
        let testingProvider = MoyaProvider<API>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        return testingProvider
    }()
    
    private let endpointClosure = { (target: API) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        var endpoint: Endpoint = Endpoint(url: url,
                                          sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                          method: target.method,
                                          task: target.task,
                                          httpHeaderFields: target.headers)
        return endpoint
    }
    
    // MARK: - Initializers
    
    public init() {}
}

// MARK: - Providers

public extension BaseService {
    var `default`: BaseService {
        self.provider = self.defaultProvider
        return self
    }
    
    var test: BaseService {
        self.provider = self.testingProvider
        return self
    }
}

// MARK: - MakeRequests

extension BaseService {
    func requestObjectInCombine<T: Decodable>(_ target: API) -> AnyPublisher<T, Error> {
        return Future { promise in
            self.provider.request(target) { response in
                switch response {
                case .success(let value):
                    do {
                        let decoder = JSONDecoder()
                        let body = try decoder.decode(T.self, from: value.data)
                        promise(.success(body))
                    } catch let error {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func requestObjectWithNetworkErrorInCombine<T: Decodable>(_ target: API) -> AnyPublisher<T, Error> {
        return Future { promise in
            self.provider.request(target) { response in
                switch response {
                case .success(let value):
                    do {
                        guard let response = value.response else { throw NSError(domain: "이 경우는 생각 업씀", code: -1000) }

                        switch response.statusCode {
                        case 200...399:
                            let decoder = JSONDecoder()
                            let body = try decoder.decode(T.self, from: value.data)
                            promise(.success(body))
                        case 400...599:
                            // NOTE: (@승호) 여기에서 서버와 에러 처리 핸들링 해서 Error도 json Decode 해야 함
                            // 임시로 Error 처리
                            throw SOPTAPPError(error: NSError(domain: "임시에러", code: -1001), statusCode: response.statusCode)
                        default: break
                        }
                    } catch let error {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func requestObjectInCombineNoResult(_ target: API) -> AnyPublisher<Int, Error> {
        return Future { promise in
            self.provider.request(target) { response in
                switch response {
                case .success(let value):
                    promise(.success(value.statusCode))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func requestObject<T: Decodable>(_ target: API, completion: @escaping (Result<T?, Error>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(T.self, from: value.data)
                    completion(.success(body))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    if error.asAFError?.isSessionTaskError ?? false {
                        
                    }
                default: break
                }
                completion(.failure(error))
            }
        }
    }
    
    func requestArray<T: Decodable>(_ target: API, completion: @escaping (Result<[T], Error>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode([T].self, from: value.data)
                    completion(.success(body))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    if error.asAFError?.isSessionTaskError ?? false {
                        
                    }
                default: break
                }
                completion(.failure(error))
            }
        }
    }
    
    func requestObjectWithNoResult(_ target: API, completion: @escaping (Result<Int?, Error>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let value):
                completion(.success(value.statusCode))
                
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    if error.asAFError?.isSessionTaskError ?? false {
                        
                    }
                default: break
                }
                completion(.failure(error))
            }
        }
    }
}
