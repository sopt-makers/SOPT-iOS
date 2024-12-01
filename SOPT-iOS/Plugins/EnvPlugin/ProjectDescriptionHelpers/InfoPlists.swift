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
        "UIAppFonts": .array([]),
            // FIXME: - 폰트 추가 후 수정
            //                "Item 0": "Pretendard-Black.otf",
            //                "Item 1": "Pretendard-Bold.otf",
            //                "Item 2": "Pretendard-ExtraBold.otf",
            //                "Item 3": "Pretendard-ExtraLight.otf",
            //                "Item 4": "Pretendard-Light.otf",
            //                "Item 5": "Pretendard-Medium.otf",
            //                "Item 6": "Pretendard-Regular.otf",
            //                "Item 7": "Pretendard-SemiBold.otf",
            //                "Item 8": "Pretendard-Thin.otf"
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "ITSAppUsesNonExemptEncryption": .boolean(false),
        "UIUserInterfaceStyle": .string("Dark"),
        "NSPhotoLibraryUsageDescription": .string("미션과 관련된 사진을 업로드하기 위해 갤러리 권한이 필요합니다."),
        "CFBundleURLTypes": .array([
            .dictionary([
                "CFBundleTypeRole": .string("Editor"),
                "CFBundleURLName": .string("sopt-makers"),
                "CFBundleURLSchemes": .array([.string("sopt-makers")])
            ])
        ]),
        "UIBackgroundModes": .array([
            .string("remote-notification")
        ])
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
        "UIAppFonts": .array([]),
          // FIXME: - 폰트 추가 후 수정
          //                "Item 0": "Pretendard-Black.otf",
          //                "Item 1": "Pretendard-Bold.otf",
          //                "Item 2": "Pretendard-ExtraBold.otf",
          //                "Item 3": "Pretendard-ExtraLight.otf",
          //                "Item 4": "Pretendard-Light.otf",
          //                "Item 5": "Pretendard-Medium.otf",
          //                "Item 6": "Pretendard-Regular.otf",
          //                "Item 7": "Pretendard-SemiBold.otf",
          //                "Item 8": "Pretendard-Thin.otf"
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "ITSAppUsesNonExemptEncryption": .boolean(false),
        "UIUserInterfaceStyle": .string("Dark"),
        "NSPhotoLibraryUsageDescription": .string("미션과 관련된 사진을 업로드하기 위해 갤러리 권한이 필요합니다."),
        "CFBundleURLTypes": .array([
            .dictionary([
                "CFBundleTypeRole": .string("Editor"),
                "CFBundleURLName": .string("sopt-makers"),
                "CFBundleURLSchemes": .array([.string("sopt-makers")])
            ])
        ]),
        "UIBackgroundModes": .array([
            .string("remote-notification")
        ])
    ]
}
