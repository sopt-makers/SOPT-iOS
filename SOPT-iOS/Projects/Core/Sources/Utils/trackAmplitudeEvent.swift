//
//  trackAmplitudeEvent.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public extension UIViewController {
    func track(event: AmplitudeEventType, otherProperties: [String: Any]? = nil) {
        let userType = UserDefaultKeyList.Auth.getUserType()
        AmplitudeInstance.shared.track(event: event, userType: userType, otherProperties: otherProperties)
    }
}
