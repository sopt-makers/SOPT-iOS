import ProjectDescription

public enum Environment {
    public static let appBundleId = "com.sopt-stamp-iOS.release"
    public static let organizationName = "SOPT-Stamp-iOS"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad])
}
