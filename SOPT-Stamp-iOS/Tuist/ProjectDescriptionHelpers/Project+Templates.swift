import Foundation
import ProjectDescription
import DependencyPlugin
import EnvPlugin

public extension Project {
    static func makeModule(
        name: String,
        targets: Set<FeatureTarget> = Set([.staticFramework, .unitTest, .demo]),
        packages: [Package] = [],
        internalDependencies: [TargetDependency] = [],  // 모듈간 의존성
        externalDependencies: [TargetDependency] = [],  // 외부 라이브러리 의존성
        interfaceDependencies: [TargetDependency] = [], // Feature Interface 의존성
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false
    ) -> Project {
        
        let hasDynamicFramework = targets.contains(.dynamicFramework)
        let deploymentTarget = Environment.deploymentTarget
        let platform = Environment.platform
        
        let settings: Settings = .settings(
            base: name.contains(Environment.workspaceName)
            ? .init().setCodeSignManualForApp()
            : .init().setCodeSignManual(),
            debug: .init()
                .setProvisioningDevelopment(),
            release: .init()
                .setProvisioningAppstore(),
            defaultSettings: .recommended)
        
        var projectTargets: [Target] = []
        var schemes: [Scheme] = []
        
        // MARK: - App
        
        if targets.contains(.app) {
            let bundleSuffix = name.contains("Demo") ? "demo" : "release"
            let infoPlist = name.contains("Demo") ? Project.demoInfoPlist : Project.appInfoPlist
            
            let target = Target(
                name: name,
                platform: platform,
                product: .app,
                bundleId: "\(Environment.bundlePrefix).\(bundleSuffix)",
                deploymentTarget: deploymentTarget,
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["Sources/**/*.swift"],
                resources: [.glob(pattern: "Resources/**", excluding: [])],
                dependencies: [
                    internalDependencies,
                    externalDependencies
                ].flatMap { $0 }
            )
            
            projectTargets.append(target)
        }
        
        // MARK: - Feature Interface
        
        if targets.contains(.interface) {
            let target = Target(
                name: "\(name)Interface",
                platform: platform,
                product:.framework,
                bundleId: "\(Environment.bundlePrefix).\(name)Interface",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Interface/Sources/**/*.swift"],
                dependencies: interfaceDependencies
            )
            
            projectTargets.append(target)
        }
        
        // MARK: - Framework
        
        if targets.contains(where: { $0.hasFramework }) {
            let deps: [TargetDependency] = targets.contains(.interface)
            ? [.target(name: "\(name)Interface")]
            : []
            
            let target = Target(
                name: name,
                platform: platform,
                product: hasDynamicFramework ? .framework : .staticFramework,
                bundleId: "\(Environment.bundlePrefix).\(name)",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Sources/**/*.swift"],
                resources: hasResources ? [.glob(pattern: "Resources/**", excluding: [])] : [],
                dependencies: deps + internalDependencies + externalDependencies
            )
            
            projectTargets.append(target)
        }
        
        // MARK: - Feature Executable
        
        if targets.contains(.demo) {
            let deps: [TargetDependency] = [.target(name: name)]
            
            let target = Target(
                name: "\(name)Demo",
                platform: platform,
                product: .app,
                bundleId: "\(Environment.bundlePrefix).\(name)Demo",
                deploymentTarget: deploymentTarget,
                infoPlist: .extendingDefault(with: Project.demoInfoPlist),
                sources: ["Demo/Sources/**/*.swift"],
                resources: [.glob(pattern: "Demo/Resources/**", excluding: ["Demo/Resources/dummy.txt"])],
                dependencies: [
                    deps,
                    [
                        .SPM.FLEX
                    ]
                ].flatMap { $0 }
            )
            
            projectTargets.append(target)
        }
        
        // MARK: - Unit Tests
        
        if targets.contains(.unitTest) {
            let deps: [TargetDependency] = targets.contains(.demo)
            ? [.target(name: name), .target(name: "\(name)Demo")] : [.target(name: name)]
            
            let target = Target(
                name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "\(Environment.bundlePrefix).\(name)Tests",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Tests/Sources/**/*.swift"],
                resources: [.glob(pattern: "Tests/Resources/**", excluding: [])],
                dependencies: [
                    deps,
                    [
                        .SPM.Nimble,
                        .SPM.Quick
                    ]
                ].flatMap { $0 }
            )
            
            projectTargets.append(target)
        }
        
        // MARK: - Schemes
        
        let additionalSchemes = targets.contains(.demo)
        ? [Scheme.makeScheme(target: .debug, name: name),
           Scheme.makeDemoScheme(target: .debug, name: name)]
        : [Scheme.makeScheme(target: .debug, name: name)]
        schemes += additionalSchemes
        
        return Project(
            name: name,
            organizationName: Environment.workspaceName,
            packages: packages,
            settings: settings,
            targets: projectTargets,
            schemes: schemes
        )
    }
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
    
    static func makeDemoScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: "\(name)Demo",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)Demo"]),
            testAction: .targets(
                ["\(name)Demo"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)Demo"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
