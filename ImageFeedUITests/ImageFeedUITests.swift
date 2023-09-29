//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Артем Чебатуров on 29.09.2023.
//

import XCTest
@testable import ImageFeed

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    // тестируем сценарий авторизации
    func testAuth() throws {
        sleep(5)

        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        sleep(5)
        print(webView.buttons)
        
        let loginTextField = webView.descendants(matching: .textField).element
        sleep(5)
        loginTextField.tap()
        loginTextField.typeText("powerslave42@yandex.ru")
        loginTextField.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(5)
        passwordTextField.tap()
        passwordTextField.typeText("1312Ab1312")
        webView.swipeUp()
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        _ = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(5)
        print(app.debugDescription)
        
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(6)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["LikeButton"].tap()
        sleep(6)
        cellToLike.buttons["LikeButton"].tap()
        
        sleep(6)
        
        cellToLike.tap()
        
        sleep(6)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
        XCTAssertTrue(app.staticTexts["loginLabel"].exists)
        sleep(5)
        app.buttons["logOutButton"].tap()
        
        app.alerts["Выход"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
