//
//  Helper.swift
//  DeliveryFood
//
//  Created by B0Dim on 03.10.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

//tv todo modificate all to singleton
class Helper {
    static let shared = Helper()
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func increment_label(from_value: Int, end_value: Int, label: UILabel)
    {
        let duration: Double = 1.0
        DispatchQueue.global().async {
            if from_value < end_value
            {
                for i in from_value ..< (end_value + 1) {
                    let sleepTime = UInt32(duration/Double(end_value) * 100000.0)
                    usleep(sleepTime)
                    DispatchQueue.main.async {
                        label.text = CURRENCY + "\(i)"
                    }
                }
            }
            else
            {
                var from = from_value
                while end_value < from
                {
                    from = from > 0 ? from - 1 : 0
                    let sleepTime = from == 0 ? UInt32(0) : UInt32(duration/Double(from) * 100000.0)
                    usleep(sleepTime)
                    DispatchQueue.main.async {
                        label.text = CURRENCY + "\(from)"
                    }
                }
            }
        }
    }
    
    func delay(_ seconds: Double, completion: @escaping () -> ())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func scrl_height(height: CGFloat, height_screen: CGFloat) -> CGFloat
    {
        if height_screen - height > 40
        {
            return height_screen + 1
        }
        else {
            return height > height_screen ? height + 60 : height_screen + 40
        }
    }
    
    //tv temp, a little better for the way of created forms here
    func getContentTopOffset (controller: UIViewController) -> CGFloat{
            if controller.navigationController != nil && !controller.navigationController!.navigationBar.isTranslucent {
                return 0
            } else {
                let barHeight=controller.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight
            }
    }
    
    func string_date_from_string(_ datetime:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertedDate = dateFormatter.date(from: datetime)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = (convertedDate != nil ? dateFormatter.string(from: convertedDate!) : "")
        return date
    }
    
    func string_time_from_string(_ datetime:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertedDate = dateFormatter.date(from: datetime)
        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "VLAT") as TimeZone!
        let time = (convertedDate != nil ? dateFormatter.string(from: convertedDate!) : "")
        return time
    }
    
    func get_today() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let str = dateFormatter.string(from: NSDate() as Date)
        let date = dateFormatter.date(from: str)
        return date!
    }
    
    func get_date_from_string(_ datetime: String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: datetime)
        return date
    }
    
    func get_now() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: NSDate() as Date)
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: str)
        return date!
    }

    func get_icon(title: String) -> String
    {
        if title.lowercased().range(of: "home") != nil
        {
            return "icon_home"
        }
        else if title.lowercased().range(of: "дом") != nil
        {
            return "icon_home"
        }
        else if title.lowercased().range(of: "раб") != nil
        {
            return "icon_office"
        }
        else if title.lowercased().range(of: "work") != nil
        {
            return "icon_office"
        }
        else if title.lowercased().range(of: "offi") != nil
        {
            return "icon_office"
        }
        else if title.lowercased().range(of: "офис") != nil
        {
            return "icon_office"
        }
        else if title.lowercased().range(of: "мой") != nil
        {
            return "icon_home"
        }
        else {
            return "icon_truck"
        }
    }

    func sort_address(array: [[String: Any]]) -> [[String: Any]]
    {
        return array.sorted {
            return $0["id"] as! Int > $1["id"] as! Int
        }
    }
    
    func getWorkDays() -> [String: [String]] {
        return combineDays(days: parseList(days: WORK_DAYS))
    }

    func getSchedules(workDays: [String: [String]]) -> String {
        var result = ""
        for (time, days) in workDays {
            let daysStr = days.count == 7 ? "Ежедневно" : days.joined(separator: ", ")
            result.append("\(daysStr): \(time)\n")
        }
        return result
    }

    func get_schedules() -> String {
        var work_days = ""
        for day in WORK_DAYS
        {
            work_days = work_days + "\n" + get_day(day: day["week_day"].stringValue) + get_time(time: day["time_start"].stringValue)
            if day["time_start"].stringValue != ""
            {
                work_days = work_days + " - " + get_time(time: day["time_end"].stringValue)
            }

        }
        return work_days
    }

    private func parseList(days: [JSON]) -> [String] {
        var parsedList = [String]()
        for day in days {
            parsedList.append(parse(day: day))
        }
        return parsedList
    }

    private func parse(day: JSON) -> String {
        let dw = get_day(day: day["week_day"].stringValue)
        if day["time_start"] == nil || day["time_end"] == nil {
            return "\(dw) Выходной"
        }
        return "\(dw) \(get_time(time: day["time_start"].stringValue))-\(get_time(time: day["time_end"].stringValue))"
    }

    private func combineDays(days: [String]) -> [String: [String]] {
        var combinedDays = [String: [String]]()
        for day in days {
            let dt = day.split(separator: " ")
            let dy = dt[0]
            let tm = dt[1]
            if combinedDays[String(tm)] == nil {
                combinedDays[String(tm)] = [String(dy)]
            } else {
                combinedDays[String(tm)]?.append(String(dy))
            }
        }
        return combinedDays
    }
    
    func get_time(time: String) -> String
    {
        var time_work = ""
        if time == ""
        {
            time_work = "Выходной"
        }
        else {
            let arr_time = time.split(separator: ":")
            time_work = arr_time[0] + ":" + arr_time[1]
            
        }
        return time_work
    }
    
    //tv зачем?! в телефоне это есть
    func get_day(day: String) -> String
    {
        var russian_day = ""
        switch day {
        case "sun":
            russian_day = "Вс. "
        case "mon":
            russian_day = "Пн. "
        case "tue":
            russian_day = "Вт. "
        case "wed":
            russian_day = "Ср. "
        case "thu":
            russian_day = "Чт. "
        case "fri":
            russian_day = "Пт. "
        default:
            russian_day = "Сб. "
        }
        return russian_day
    }
    
    ///получить список расписанияб из json объекта, в будущем использовать только его
    public func getScheduleDict(jsonSchedule: [JSON]) -> [String:(sh: Int, sm: Int, eh: Int, em: Int)] {
        func getTimeTupleFromString(_ time: String) -> (Int, Int) {
            var result = (hour: 0, min:0)
            if time != "" {
                let arr_time = time.split(separator: ":")
                result = (hour: Int(arr_time[0])!, min: Int(arr_time[1])!)
            }
            return result
        }
        
        func schedulerItemToTuple(day: JSON) -> (Int,Int,Int,Int) {
            var startTuple = (0,0)
            var endTuple = (0,0)
            
            if day["time_start"] == JSON.null  || day["time_end"] == JSON.null  {
                
            } else {
                startTuple = getTimeTupleFromString(day["time_start"].stringValue)
                endTuple = getTimeTupleFromString(day["time_end"].stringValue)
            }
            return (startTuple.0, startTuple.1, endTuple.0, endTuple.1)
        }
        
        var list = [String:(Int,Int,Int,Int)]()
        for day in jsonSchedule {
            list[day["week_day"].stringValue] = schedulerItemToTuple(day: day)
        }
        return list
    }
    
}
