//
//  MediaService.swift
//  Networks
//
//  Created by Ian on 4/7/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire

public final class DefaultMediaService { 
  public init() { }
}

public protocol MediaService {
  func uploadMedia(imageData: Data, to presignedUrl: String) -> AnyPublisher<Void, Error>
}

extension DefaultMediaService: MediaService {
  // NOTE(@승호): 
  // 1. mediaAPI는 base 주소 대신 응답으로 받은 url에 put 전송이 필요하여 BaseAPI를 구현할 수 없어요.
  // 2. Moya에서 multipartForm을 구현하면 HTTPHeader에 이상한 값이 붙어요. 그래서 직접 Alamofire 함수를 호출했습니다.
  public func uploadMedia(imageData: Data, to presignedUrl: String) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      guard let url = URL(string: presignedUrl) else {
        return promise(.failure(NSError(domain: "url encode error", code: -1)))
      }
      
      AF
        .upload(imageData, to: url, method: .put)
        .response(queue: .global(qos: .userInitiated), completionHandler: { response in
          switch response.result {
          case .success:
            promise(.success(Void()))
          case .failure(let error):
            promise(.failure(error))
          }
        })
    }
    .eraseToAnyPublisher()
  }
}
