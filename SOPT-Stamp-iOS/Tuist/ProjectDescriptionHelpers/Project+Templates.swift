import ProjectDescription
import UtilityPlugin
import Foundation

public extension Project {
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        hasTest: Bool = false
    ) -> Project {
        return project(
            name: name,
            platform: platform,
            product: product,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            resources: resources,
            infoPlist: infoPlist,
            hasTest: hasTest
        )
    }
}

// Environment.organizationName / Environment.deploymentTarget

public extension Project {
    static func project(
        name: String,
        platform: Platform,
        product: Product,
        organizationName: String = "SOPT-Stamp-iOS",
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist,
        hasTest: Bool = false
    ) -> Project {
        
        let settings: Settings = .settings(
            base: product == .app
                ? .init().setCodeSignManualForApp()
                : .init().setCodeSignManual(),
            debug: .init()
                .setProvisioningDevelopment(),
            release: .init()
                .setProvisioningAppstore(),
            defaultSettings: .recommended)
        
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

        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = hasTest
        ? [appTarget, makeTestTarget(name: name)]
        : [appTarget]

        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}

public extension Project {
    static func makeTestTarget(name: String) -> Target {
        return Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "SOPT-Stamp-iOS.\(name)Tests",
            deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: name)]
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
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
