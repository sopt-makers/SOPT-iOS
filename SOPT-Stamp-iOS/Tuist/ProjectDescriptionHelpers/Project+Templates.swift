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
        hasTest: Bool = false,
        hasDemoApp: Bool = false
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
            hasTest: hasTest,
            hasDemoApp: hasDemoApp
        )
    }
}

public extension Project {
    static func project(
        name: String,
        platform: Platform,
        product: Product,
        organizationName: String = Environment.organizationName,
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = Environment.deploymentTarget,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist,
        hasTest: Bool = false,
        hasDemoApp: Bool = false
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
        
        let bundleId = (name == "SOPT-Stamp-iOS")
        ? Environment.appBundleId
        : "\(organizationName).\(name)"
        
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
        
        let demoAppTarget: Target = {
            let demoSource: SourceFilesList = ["Demo/Sources/**", "Derived/Sources/**"]
            let demoSources: SourceFilesList = SourceFilesList(globs: sources.globs + demoSource.globs)
            let demoResources: ResourceFileElements = ["Demo/Resources/**", "Resources/**"]
            return makeDemoAppTarget(name: name, sources: demoSources, resources: demoResources)
        }()
        
        let schemes: [Scheme] = hasDemoApp
        ? [.makeScheme(target: .debug, name: name), .makeDemoScheme(target: .debug, name: name)]
        : [.makeScheme(target: .debug, name: name)]
        
        var targets: [Target]
        switch (hasTest, hasDemoApp) {
        case (true, true):
            targets = [appTarget, makeTestTarget(name: name, isDemo: true), demoAppTarget]
        case (true, false):
            targets = [appTarget, makeTestTarget(name: name)]
        case (false, true):
            targets = [appTarget, demoAppTarget]
        case (false, false):
            targets = [appTarget]
        }
        
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
    static func makeTestTarget(name: String, isDemo: Bool = false) -> Target {
        let testTargetDependencies: [TargetDependency] = isDemo
        ? [.target(name: "\(name)DemoApp"), .SPM.Nimble, .SPM.Quick]
        : [.target(name: name), .SPM.Nimble, .SPM.Quick]
        return Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "\(Environment.organizationName)\(name)Tests",
            deploymentTarget: Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: testTargetDependencies
        )
    }
    
    static func makeDemoAppTarget(name: String, sources: SourceFilesList, resources: ResourceFileElements) -> Target {
        return Target(
            name: "\(name)DemoApp",
            platform: .iOS,
            product: .app,
            bundleId: "\(Environment.organizationName).\(name)DemoApp",
            deploymentTarget: Environment.deploymentTarget,
            infoPlist: .extendingDefault(with: baseinfoPlist),
            sources: sources,
            resources: resources,
            scripts: [.SwiftLintString],
            dependencies: [
                .target(name: name)
            ]
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
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)DemoApp"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)DemoApp"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
