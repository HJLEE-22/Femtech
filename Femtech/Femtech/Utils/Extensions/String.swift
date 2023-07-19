//
//  String.swift
//  Femtech
//
//  Created by Lee on 2023/07/18.
//

import Foundation

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 사용 예시
    // ("\(presentedYear)-\(presentedMonth)-01".date?.firstdayOfMonth.weekday)!
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
