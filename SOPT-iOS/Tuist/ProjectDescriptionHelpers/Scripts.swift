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
    
    static let Sentry = TargetScript.pre(
        script: """
if [ "${CONFIGURATION}" == "QA" ] || [ "${CONFIGURATION}" == "PROD" ]; then
if which sentry-cli >/dev/null; then
export SENTRY_ORG=sopt-1a
export SENTRY_PROJECT=sopt-ios
export SENTRY_AUTH_TOKEN=$SENTRY_AUTH_TOKEN
ERROR=$(sentry-cli upload-dif --include-sources "$DWARF_DSYM_FOLDER_PATH" --force-foreground 2>&1 >/dev/null)
if [ ! $? -eq 0 ]; then
echo "error: sentry-cli - $ERROR"
fi
else
echo "error: sentry-cli not installed, download from https://github.com/getsentry/sentry-cli/releases"
fi
fi
""",
        name: "Sentry",
        inputPaths: ["${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}"],
        basedOnDependencyAnalysis: false
    )
}
