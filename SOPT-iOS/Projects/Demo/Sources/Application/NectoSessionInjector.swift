//
//  NectoSessionInjector.swift
//  SOPT-iOS-Demo
//
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

#if DEBUG
import Foundation
import ObjectiveC

import NectoURLSessionCapture

/// `URLSessionConfiguration.default`로 만든 세션(Alamofire/Moya 포함)에 Necto의 URLProtocol을 주입한다.
///
/// Necto는 `URLProtocol.registerClass`로 전역 등록하지만, 직접 구성한 세션에는 적용되지 않아
/// 세션의 `protocolClasses`에 `NectoURLSessionCapture.protocolClass`가 있어야 한다.
/// 공용 모듈을 수정하지 않고 Demo에서만 주입하기 위해 `URLSessionConfiguration.default` getter를 교체한다.
enum NectoSessionInjector {
    private static let installOnce: Void = {
        let configurationClass: AnyClass = URLSessionConfiguration.self
        guard
            let original = class_getClassMethod(
                configurationClass,
                #selector(getter: URLSessionConfiguration.default)
            ),
            let injected = class_getClassMethod(
                configurationClass,
                #selector(URLSessionConfiguration.necto_injectedDefault)
            )
        else { return }
        method_exchangeImplementations(original, injected)
    }()

    static func install() {
        _ = installOnce
    }
}

private extension URLSessionConfiguration {
    /// 구현이 교체된 뒤에는 `necto_injectedDefault()` 호출이 원래의 `default`를 가리킨다.
    @objc class func necto_injectedDefault() -> URLSessionConfiguration {
        let configuration = necto_injectedDefault()
        configuration.protocolClasses = [NectoURLSessionCapture.protocolClass]
            + (configuration.protocolClasses ?? [])
        return configuration
    }
}
#endif
