import ProjectDescription
import UtilityPlugin

public extension Project {
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        organizationName: String = "SOPT-Stamp-iOS",
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default
    ) -> Project {
        
        /// Settings
        /// - base: custom을 원하면, key-value 형태로 추가 가능
        /// - configurations: project의 configurations 설정
        /// - defaultSettings: xcconfig 사용하는 경우 .none으로 하는게 편함
        let settings: Settings = .settings(
            base:
                product == .app ? .init().setCodeSignManualForApp() : .init().setCodeSignManual(),
            debug: .init()
                .setProvisioningDevelopment(),
            release: .init()
                .setProvisioningAppstore(),
            defaultSettings: .recommended)
        
        /// Targets
        /// - test 용으로 TestTarget 정의 후, appTarget에 대한 dependency 설정
        ///
        let bundleId = (name == "SOPT-Stamp-iOS") ? "com.sopt-stamp-iOS.release" : "\(organizationName).\(name)"
        
        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: bundleId,
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            scripts: [.SwiftLintString],
            dependencies: dependencies
        )
        
//        let testTarget = Target(
//            name: "\(name)Tests",
//            platform: platform,
//            product: .unitTests,
//            bundleId: "\(organizationName).\(name)Tests",
//            deploymentTarget: deploymentTarget,
//            infoPlist: .default,
//            sources: ["Tests/**"],
//            dependencies: [.target(name: name)] // appTarget에 대한 dependency
//        )
        
        let targets: [Target] = [appTarget]
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
    
    static let baseinfoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0.0",
            "CFBundleVersion": "1",
            "CFBundleIdentifier": "com.sopt-stamp-iOS.release",
            "CFBundleDisplayName": "SOPT-Stamp",
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ],
                    ]
                ]
            ],
            "UIAppFonts": [
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
            ],
            "App Transport Security Settings": ["Allow Arbitrary Loads": true],
            "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
            "ITSAppUsesNonExemptEncryption": false
        ]
}

extension Scheme {
    /// Scheme 생성하는 method
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
