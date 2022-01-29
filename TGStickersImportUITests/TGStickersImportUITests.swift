//
//  TGStickersImportUITests.swift
//  TGStickersImportUITests
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import XCTest

class TGStickersImportUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGallery() throws {
        let _ = XCUIApplication(view: "gallery")
        
        sleep(5)
        snapshot("01GalleryView01")
        snapshot("01GalleryView02")
        snapshot("01GalleryView03")
        snapshot("01GalleryView04")
        sleep(1)
        snapshot("01GalleryView05")
        sleep(1)
        snapshot("01GalleryView06")
        sleep(1)
        snapshot("01GalleryView07")
        sleep(1)
        snapshot("01GalleryView08")
        snapshot("01GalleryView09")
        snapshot("01GalleryView10")
    }
    
    func testRecognition() throws {
        let app = XCUIApplication(view: "recognition")

        let textField = app.textFields["Aa.."]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: textField, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        textField.tap()
        textField.typeText("John")
        let returnButton = XCUIApplication().keyboards.buttons["return"]
        if returnButton.exists {
            returnButton.tap()
        }
        /*let nextButton = XCUIApplication().keyboards.buttons["next"]
        if nextButton.exists {
            nextButton.tap()
        }*/
        
        sleep(1)
        snapshot("02RecognitionView")
    }
    
    func testSelection() throws {
        let app = XCUIApplication(view: "selection")
        
        let button = app.buttons["Done"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        sleep(1)
        snapshot("03SelectionView01")
        sleep(1)
        snapshot("03SelectionView02")
        snapshot("03SelectionView03")
        sleep(1)
        snapshot("03SelectionView04")
        sleep(1)
        snapshot("03SelectionView05")
        snapshot("03SelectionView06")
        sleep(1)
        snapshot("03SelectionView07")
        sleep(1)
        snapshot("03SelectionView08")
        snapshot("03SelectionView09")
        snapshot("03SelectionView10")
    }
}

extension XCUIApplication {
    // Init the Application with selected view
    convenience init(view: String) {
        self.init()
        self.launchArguments.append("test")
        self.launchEnvironment["view"] = view
        
        if ProcessInfo.processInfo.arguments.contains("SKIP_ANIMATIONS") {
            setupSnapshot(self, waitForAnimations: false)
        } else {
            setupSnapshot(self)
        }
                
        self.launch()
    }
}
