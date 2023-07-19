//
//  Date.swift
//  Femtech
//
//  Created by Lee on 2023/07/18.
//

import Foundation

extension Date {
    var weekday: Int {
        get {
            Calendar.current.component(.weekday, from: self)
        }
    }
    var firstdayOfMonth: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        }
    }
}
