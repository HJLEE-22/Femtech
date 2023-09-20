//
//  User.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/04.
//

import Foundation

struct UserSignUpModel: Codable {
    var result: Bool
    var msg: String
    var data: [UserData]
    
    struct UserData: Codable {
        var email: String
        var accessToken: String?
        var refreshToken: String?
//        var msg: String?
//        var type: String?
        
        enum CodingKeys: String, CodingKey {
            case email
            case accessToken
            case refreshToken
//            case msg
//            case type = "com_type"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.email = try container.decode(String.self, forKey: .email)
            self.accessToken = try? container.decode(String.self, forKey: .accessToken)
            self.refreshToken = try? container.decode(String.self, forKey: .refreshToken)
//            self.msg = try? container.decode(String.self, forKey: .msg)
//            self.type = try? container.decode(String.self, forKey: .type)
        }
    }
    enum CodingKeys: String, CodingKey {
        case result
        case msg
        case data
    }
}

struct UserLogInModel: Codable {
    var result: Bool
    var msg: String
    var data: [UserData]
    
    struct UserData: Codable {
        var email: String
        var accessToken: String
        var refreshToken: String
    }
    
    enum CodingKeys: String, CodingKey {
        case result
        case msg
        case data
    }
}
