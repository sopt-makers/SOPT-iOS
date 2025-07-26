//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by devxsby on 2022/10/02.
//

import ProjectDescription

public extension TargetScript {
    static let SwiftLintString = TargetScript.pre(script: """
if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftlint > /dev/null; then
    swiftlint autocorrect && swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
""", name: "SwiftLintString", basedOnDependencyAnalysis: false)
    
    static let googleServiceInfo = TargetScript.pre(
    script: """
    case "${TARGET_NAME}" in
    "SOPT-iOS" )
      cp -r "$SRCROOT/Resources/GoogleService-Info.plist" \\
            "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
      ;;
    "SOPT-iOS-Demo" )
      cp -r "$SRCROOT/../Demo/Resources/GoogleService-Info.plist" \\
            "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
      ;;
    esac
    """,
    name: "Copy GoogleService-Info.plist"
    )
    
    static let uploadDSYMToFirebaseScript = TargetScript.post(
      script: """
        "$SRCROOT/../../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
      """,
      name: "Upload dSYM to Firebase",
      inputPaths: [
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
        "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
        "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}.debug.dylib"
      ]
    )
}
