//
//  MockCoordinator.swift
//  RootFeatureTests
//
//  Created by sejin on 1/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency


class MockCoordinator: BaseCoordinator {
   var childViewNames: [String] = []
   
   func runMockFlow(viewName: String) {
       self.childViewNames.append(viewName)
   }
}
