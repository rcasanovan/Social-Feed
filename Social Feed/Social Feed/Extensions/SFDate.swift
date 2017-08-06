//
//  SFDate.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 06/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import Foundation

extension Date {
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dtf.string(from: self)
    }
    
    func ddMMMyyyyFormat() -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    static func getDateFromTwitterFormart(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss +0000 yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: stringDate)
        return date!
    }
}
