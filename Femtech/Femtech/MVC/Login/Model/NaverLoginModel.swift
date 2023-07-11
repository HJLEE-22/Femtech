//
//  NaverLoginModel.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/07.
//

import Foundation

//네이버 사용자 정보를 받아올 구조체
struct NaverLoginModel: Decodable {
    
    var resultCode: String
    var response: Response
    var message: String
    
    struct Response: Decodable {
        var email: String
        var id: String
        var name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case response
        case message
    }
}
