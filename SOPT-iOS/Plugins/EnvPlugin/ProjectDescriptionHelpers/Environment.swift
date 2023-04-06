import ProjectDescription

public enum Environment {
    public static let workspaceName = "SOPT-iOS"
}

public extension Project {
    enum Environment {
        public static let workspaceName = "SOPT-iOS"
        public static let deploymentTarget = DeploymentTarget.iOS(targetVersion: "16.0", devices: [.iphone])
        public static let platform = Platform.iOS
        public static let bundlePrefix = "com.sopt-stamp-iOS"
    }
}
