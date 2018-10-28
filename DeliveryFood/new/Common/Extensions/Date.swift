//
//  Date.swift
//  DeliveryFood
//
//  Created by Admin on 07/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public extension Date {
    func setTime(hour: Int = -1, minute: Int = -1, second: Int = 0) -> Date
    {
        let cal = Calendar(identifier: .gregorian)
        var components = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        if hour >= 0 {
            components.hour = hour
        }
        if minute >= 0 {
            components.minute = minute
        }
        components.second = second
        return cal.date(from: components)!
    }
    
    ///получить день недели в определенной тайм зоне
    ///нужна когда клиент в другой таймзоне, но нужно знать какой день неделе, где кафе
    func getShortWeekDay(forTimeZone tz: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: tz * 3600)!
        dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ssZZZZ"
        debugPrint("day ", dateFormatter.string(from: (self as Date)))
        
        dateFormatter.dateFormat = "ccc"
        let weekDayName = dateFormatter.string(from: (self as Date))
        debugPrint ("week day ", weekDayName)
        
        return weekDayName
    }
    
    //round date
    func round(precision: TimeInterval, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Date {
        let seconds = (self.timeIntervalSinceReferenceDate / precision).rounded(rule) *  precision;
        return Date(timeIntervalSinceReferenceDate: seconds)
    }
}
