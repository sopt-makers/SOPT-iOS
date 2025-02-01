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
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Tests", sourcePath: "./"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Tests/Sources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Tests/Sources/.empty", templatePath: ".empty"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Tests/Resources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Tests/Resources/.empty", templatePath: ".empty"),
        
        // Sources
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Sources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Sources/.empty", templatePath: ".empty"),
        
        // Interface
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Interface", sourcePath: "./"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Interface/Sources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Interface/Sources/.empty", templatePath: ".empty"),
        
        // Derived
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Derived", sourcePath: "./"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Derived/Sources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Derived/Sources/.empty", templatePath: ".empty"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Derived/InfoPlists", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Derived/InfoPlists/Info.plist", templatePath: "Info.plist"),
        
        // Demo
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Demo", sourcePath: "./"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Demo/Resources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Demo/Sources/LaunchScreen.storyboard", templatePath: "LaunchScreen.storyboard"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Demo/Sources/Assets.xcassets", sourcePath: "Assets.xcassets"),
        .directory(path: "Projects/Features/\(nameAttribute)Feature/Demo/Sources", sourcePath: "./"),
        .file(path: "Projects/Features/\(nameAttribute)Feature/Demo/Sources/.empty", templatePath: ".empty"),
    ]
)
