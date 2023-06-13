import XCTest

public extension XCUIApplication {
    var alertAllowButton: XCUIElement {
        let currentLocale = Locale.current.identifier
        return currentLocale.hasPrefix("ko")
        ? alerts.buttons["허용"]
        : alerts.buttons["Allow"]
    }
    
    var okButton: XCUIElement {
        let currentLocale = Locale.current.identifier
        return currentLocale.hasPrefix("ko")
        ? buttons["확인"]
        : buttons["OK"]
    }
}
