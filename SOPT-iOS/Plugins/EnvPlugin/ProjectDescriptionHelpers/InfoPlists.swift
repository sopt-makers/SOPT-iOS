import ProjectDescription

public extension Project {
    static let appInfoPlist: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string("1.0.0"),
        "CFBundleDevelopmentRegion": .string("ko"),
        "CFBundleVersion": .string("1"),
        "CFBundleIdentifier": .string("com.sopt-stamp-iOS.release"),
        "CFBundleDisplayName": .string("SOPT"),
        "UILaunchStoryboardName": .string("LaunchScreen"),
        "UIApplicationSceneManifest": .dictionary([
                "UIApplicationSupportsMultipleScenes": .boolean(false),
                "UISceneConfigurations": .dictionary([
                    "UIWindowSceneSessionRoleApplication": .array([
                        .dictionary([
                            "UISceneConfigurationName": .string("Default Configuration"),
                            "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                        ])
                    ])
                ])
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "ITSAppUsesNonExemptEncryption": .boolean(false),
        "UIUserInterfaceStyle": .string("Dark"),
        "NSPhotoLibraryUsageDescription": .string("미션과 관련된 사진을 업로드하기 위해 갤러리 권한이 필요합니다."),
        "GIDClientID": .string("$(GOOGLE_IOS_CLIENT_ID)"),
        "GIDServerClientID": .string("$(GOOGLE_SERVER_CLIENT_ID)"),
        "CFBundleURLTypes": .array([
            .dictionary([
                "CFBundleTypeRole": .string("Editor"),
                "CFBundleURLName": .string("sopt-makers"),
                "CFBundleURLSchemes": .array([.string("sopt-makers")])
            ]),
            .dictionary([
                "CFBundleTypeRole": .string("Editor"),
                "CFBundleURLName": .string("Google"),
                "CFBundleURLSchemes": .array([.string("$(GOOGLE_IOS_REVERSED_CLIENT_ID)")])
            ])
        ]),
        "UIBackgroundModes": .array([
            .string("remote-notification")
        ]),
        "AppID": .string("6444594319")
    ]
    
    static let demoInfoPlist: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string("1.0.0"),
        "CFBundleDevelopmentRegion": .string("ko"),
        "CFBundleVersion": .string("1"),
        "CFBundleIdentifier": .string("com.sopt-stamp-iOS.alpha"),
        "CFBundleDisplayName": .string("SOPT-Test"),
        "UILaunchStoryboardName": .string("LaunchScreen"),
        "UIApplicationSceneManifest": .dictionary([
            "UIApplicationSupportsMultipleScenes": .boolean(false),
            "UISceneConfigurations": .dictionary([
                "UIWindowSceneSessionRoleApplication": .array([
                    .dictionary([
                        "UISceneConfigurationName": .string("Default Configuration"),
                        "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                    ])
                ])
            ])
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "ITSAppUsesNonExemptEncryption": .boolean(false),
        "UIUserInterfaceStyle": .string("Dark"),
        "NSPhotoLibraryUsageDescription": .string("미션과 관련된 사진을 업로드하기 위해 갤러리 권한이 필요합니다."),
        "SENTRY_AUTH_TOKEN": .string("$(SENTRY_AUTH_TOKEN)"),
        "GIDClientID": .string("$(GOOGLE_IOS_CLIENT_ID)"),
        "GIDServerClientID": .string("$(GOOGLE_SERVER_CLIENT_ID)"),
        "CFBundleURLTypes": .array([
            .dictionary([
                "CFBundleTypeRole": .string("Editor"),
                "CFBundleURLName": .string("sopt-makers"),
                "CFBundleURLSchemes": .array([.string("sopt-makers")])
            ]),
            .dictionary([
                "CFBundleTypeRole": .string("Editor"),
                "CFBundleURLName": .string("Google"),
                "CFBundleURLSchemes": .array([.string("$(GOOGLE_IOS_REVERSED_CLIENT_ID)")])
            ])
        ]),
        "UIBackgroundModes": .array([
            .string("remote-notification")
        ]),
        "AppID": .string("6444594319")
    ]
}
