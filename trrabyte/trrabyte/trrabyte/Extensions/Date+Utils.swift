//
//  Date+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation

extension Date {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        let locale = NSLocale.current
        let timeZone = NSTimeZone.local
       
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func numberOfDaysBetweenTodayAndDate() -> Int {
        let calendar = NSCalendar.current
        let dateOne = calendar.startOfDay(for: self)
        let dateTwo = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: dateOne, to: dateTwo)
        
        return components.day ?? 300
    }
}
