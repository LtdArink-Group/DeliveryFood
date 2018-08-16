//
//  ExtensionsTests.swift
//  DeliveryFoodTests
//
//  Created by Admin on 24/07/2018.
//  Copyright © 2018 B0Dim. All rights reserved.
//

import XCTest

class ExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetWeekDayForTimeZone() {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        
        let date = dateFormatterGet.date(from: "2018-07-24 01:24:26+11")
        
        
        XCTAssertEqual(date?.getShortWeekDay(forTimeZone: 10), "Tue", "Дни в часовом поясе еще совпадает, ждем вторника")
        XCTAssertEqual(date?.getShortWeekDay(forTimeZone: 9), "Mon", "На один день раньше, значит тут ждем понедельник")
    }
    
    
    func testIsValidAddressByRegexp() {
        let addressPattern = "^.{3,}[,\\ ]\\d+.*$"
        
        XCTAssertTrue("sdsd ds, 34".isValid(regExp: addressPattern));
        XCTAssertTrue("выаа аыва 4ф/3".isValid(regExp: addressPattern));
        XCTAssertFalse("sdsd ds df4".isValid(regExp: addressPattern));
        XCTAssertFalse("вы 44".isValid(regExp: addressPattern));
    }
    
    
}
