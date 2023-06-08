import XCTest
import Core
import TestCore

class AppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    override func tearDown() {
        let screenshot = XCUIScreen.main.screenshot()
        let fullScreenshotAttachment = XCTAttachment(screenshot: screenshot)
        fullScreenshotAttachment.lifetime = .keepAlways
        add(fullScreenshotAttachment)
        app.terminate()
    }
    
    func testVisitorFlow() throws {
        
        UserDefaultKeyList.clearAllUserData()
        
        app.alertAllowButton.tapIfExist()
        
        app.buttons["SOPT 회원이 아니에요"].tap()
        app.buttons["btn mypage"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.staticTexts["개인정보 처리 방침"].tap()
        
        let opArrowwhiteButton = app.buttons["op arrowWhite"]
        opArrowwhiteButton.tap()
        elementsQuery.staticTexts["서비스 이용 약관"].tap()
        opArrowwhiteButton.tap()
        elementsQuery.staticTexts["로그인"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["SOPT 회원이 아니에요"]/*[[".buttons[\"SOPT 회원이 아니에요\"].staticTexts[\"SOPT 회원이 아니에요\"]",".staticTexts[\"SOPT 회원이 아니에요\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["SOPT \n공식홈페이지"]/*[[".cells.staticTexts[\"SOPT \\n공식홈페이지\"]",".staticTexts[\"SOPT \\n공식홈페이지\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let webView = app.webViews.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: webView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
