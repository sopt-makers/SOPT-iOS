import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToFeature(_ path: String) -> Self {
        return .relativeToRoot("Projects/Features/\(path)")
    }
    
    static func relativeToModules(_ path: String) -> Self {
        return .relativeToRoot("Projects/Modules/\(path)")
    }
    
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
    
    static var data: Self {
        return .relativeToRoot("Projects/Data")
    }
    
    static var domain: Self {
        return .relativeToRoot("Projects/Domain")
    }
    
    static var core: Self {
        return .relativeToRoot("Projects/Core")
    }
}
