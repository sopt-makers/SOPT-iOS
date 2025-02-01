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
    ]
)
