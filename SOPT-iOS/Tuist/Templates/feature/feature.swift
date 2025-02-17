//
//  feature.swift
//  ProjectDescriptionHelpers
//
//  Created by 강윤서 on 2/1/25.
//

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let author: Template.Attribute = .required("author")
let currentDate: Template.Attribute = .required("current_date")

let template = Template(
    description: "Creates a new feature module",
    attributes: [
        nameAttribute,
        author,
        currentDate
    ],
    items: ModuleTemplate.allCases.flatMap{ $0.item }
)

enum ModuleTemplate: CaseIterable {
    case main, tests, sources, interface, derived, demo
    
    var path: String {
        switch self {
        case .main:
            return .basePath
        case .tests:
            return .basePath + "/Tests"
        case .sources:
            return .basePath + "/Sources"
        case .interface:
            return .basePath + "/Interface"
        case .derived:
            return .basePath + "/Derived"
        case .demo:
            return .basePath + "/Demo"
        }
    }
    
    var item: [Template.Item] {
        switch self {
        case .main:
            return [.directory(path: path, sourcePath: ""),
                    .file(path: path + "/Project.swift", templatePath: "Project.stencil")]
        case .tests:
            return [.file(path: path + "/Sources/Empty.swift", templatePath: "Empty.stencil"),
                    .file(path: path + "/Resources/Empty.swift", templatePath: "Empty.stencil")]
        case .sources:
            return [.file(path: path + "/Empty.swift", templatePath: "Empty.stencil")]
        case .interface:
            return [.file(path: path + "/Sources/Empty.swift", templatePath: "Empty.stencil")]
        case .derived:
            return [.file(path: path + "/Sources/Empty.swift", templatePath: "Empty.stencil"),
                    .file(path: path + "/InfoPlists/Info.plist", templatePath: "Info.plist")]
        case .demo:
            return [.file(path: path + "/Resources/LaunchScreen.storyboard", templatePath: "LaunchScreen.storyboard"),
                    .directory(path: path + "/Resources/Assets.xcassets", sourcePath: "Assets.xcassets"),
                    .file(path: path + "/Sources/Empty.swift", templatePath: "Empty.stencil")]
        }
    }
}

extension String {
    static var basePath: Self {
        return "Projects/Features/\(nameAttribute)Feature"
    }
}
