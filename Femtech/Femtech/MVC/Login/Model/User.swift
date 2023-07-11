//
//  User.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/04.
//

import Foundation

struct User: Codable {
    var userName: String?
    var email: String?
    
    enum codingKeys: String, CodingKey {
        case userName = "userName"
        case email = "email"
    }
}
