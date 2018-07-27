//
//  HelperTests.swift
//  DeliveryFoodTests
//
//  Created by Admin on 24/07/2018.
//  Copyright © 2018 B0Dim. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import DeliveryFood

class HelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        /*
 {"id":1,"name":"Burgx","categories":[1,2,11,6,12],"description":"В Burgx вас всегда ждет уютная, гостеприимная атмосфера. это сочные и сильные бургеры только из 100% натуральной мраморной говядины. \nБургерная Burgx - это натуральные и качественные бургеры по демократичным ценам, для широкой аудитории!","contact_info":{"email":"booking@noxfox.ru","phone":"+7 (4212) 699-207","geotag":["48.483257,135.094393"],"geotag_cafe":["48.483257,135.094393"]},"delivery":{"cost":150,"period":{"end":"19:30 +10","start":"12:00 +10"},"free_shipping":800,"pickup_discount":10},"created_at":"2017-12-19T16:57:52.177+10:00","updated_at":"2018-04-29T17:13:43.688+10:00","addresses":[{"id":223,"title":"Burgx","city":"Хабаровск","street":"ул. Ленинградская","house":"28Г3","office":null,"entrance":null,"floor":null,"code":null,"created_at":"2018-04-29T17:13:43.675+10:00","updated_at":"2018-04-29T17:13:43.675+10:00"}],"schedules":[{"id":1,"company_id":1,"week_day":"sun","time_start":"11:30:00+10","time_end":"23:30:00+10"},{"id":2,"company_id":1,"week_day":"mon","time_start":"11:30:00+10","time_end":"23:30:00+10"},{"id":3,"company_id":1,"week_day":"tue","time_start":"11:30:00+10","time_end":"23:30:00+10"},{"id":4,"company_id":1,"week_day":"wed","time_start":"11:30:00+10","time_end":"23:30:00+10"},{"id":5,"company_id":1,"week_day":"thu","time_start":"11:30:00+10","time_end":"23:30:00+10"},{"id":6,"company_id":1,"week_day":"fri","time_start":"11:30:00+10","time_end":"23:30:00+10"},{"id":7,"company_id":1,"week_day":"sat","time_start":"11:30:00+10","time_end":"23:30:00+10"}]}
 */
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getWorkHours(weakDay: String, workDays: [String:(String, String)]) {

        
        let workday = workDays[weakDay]
        debugPrint(workday as Any)
    }

    
   
    func testGettingWorkHours() {
        let strSchedules = """
        [{\"id\":1,\"company_id\":1,\"week_day\":\"sun\",\"time_start\":\"11:30:00+10\",\"time_end\":\"23:30:00+10\"},
        {\"id\":2,\"company_id\":1,\"week_day\":\"mon\",\"time_start\":\"10:10:00+10\",\"time_end\":\"17:30:00+10\"},
        {\"id\":3,\"company_id\":1,\"week_day\":\"tue\",\"time_start\":\"11:30:00+10\",\"time_end\":\"23:30:00+10\"},
        {\"id\":4,\"company_id\":1,\"week_day\":\"wed\",\"time_start\":\"\",\"time_end\":\"23:30:00+10\"},
        {\"id\":5,\"company_id\":1,\"week_day\":\"thu\"}
        ]
        """
        
        var jsonSchedule: [JSON]!
        let data = strSchedules.data(using: .utf8)!

        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                jsonSchedule = JSON(jsonArray).arrayValue
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            debugPrint(error)
            XCTAssertThrowsError(error)
        }
        
        let helper = Helper()
        
        let scheduleDict = helper.getScheduleDict(jsonSchedule: jsonSchedule)
        debugPrint(scheduleDict)
        XCTAssertTrue(scheduleDict["sun"]! == (11,30,23,30),    "1 версия расписания на день, ожидается sun:(11,30,23,30)")
        XCTAssertTrue(scheduleDict["mon"]! == (10,10,17,30),    "2 версия расписания на день, ожидается mon:(10,10,17,30)")
        XCTAssertTrue(scheduleDict["wed"]! == (0,0,23,30),      "пустое время начала")
        XCTAssertTrue(scheduleDict["thu"]! == (0,0,0,0),        "нет времени начала и конца")

    }
    
}
