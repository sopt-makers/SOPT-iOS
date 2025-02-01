//
//  feature.swift
//  ProjectDescriptionHelpers
//
//  Created by 강윤서 on 2/1/25.
//

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Creates a new feature module",
    attributes: [
        nameAttribute
    ],
    items: [
        // Main
        .directory(path: "Projects/Features/\(nameAttribute)Feature", sourcePath: ""),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Project.swift", templatePath: "Project.stencil"),
        
        // Tests
        .file(path: "Projects/Features/\(nameAttribute)Feature/Tests/Sources/Empty.swift", templatePath: "Empty.stencil"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Tests/Resources/Empty.swift", templatePath: "Empty.stencil"),
        
        // Sources
        .file(path: "Projects/Features/\(nameAttribute)Feature/Sources/Empty.swift", templatePath: "Empty.stencil"),
        
        // Interface
        .file(path: "Projects/Features/\(nameAttribute)Feature/Interface/Sources/Empty.swift", templatePath: "Empty.stencil"),
        
        // Derived
        .file(path: "Projects/Features/\(nameAttribute)Feature/Derived/Sources/Empty.swift", templatePath: "Empty.stencil"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Derived/InfoPlists/Info.plist", templatePath: "Info.plist"),
        
        // Demo
        .file(path: "Projects/Features/\(nameAttribute)Feature/Demo/Resources/LaunchScreen.storyboard", templatePath: "LaunchScreen.storyboard"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Demo/Resources/Assets.xcassets", sourcePath: "Assets.xcassets"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Demo/Sources/Empty.swift", templatePath: "Empty.stencil"),
    ]
)
