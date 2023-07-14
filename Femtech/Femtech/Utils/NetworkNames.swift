//
//  NetworkNames.swift
//  Femtech
//
//  Created by Lee on 2023/07/13.
//

import Foundation

public struct NetworkNames {
    private init() {}
    // DEV API 기본 URL (QSCheck)
    static let devQSReaderApi = "https://dev.qsreader.com/api"
    // 음식제안 URL (QSCheck)
    static let foodCategoryApi = "\(devQSReaderApi)/food?category_id="
    // sign up URL
    static let devSignUpApi = "http://3.34.137.105:8080/api/signup/?"
    // log in URL
    static let devLogInApi = "http://3.34.137.105:8080/api/login/?"
    // 네이버 로그인 url
    static let naverLoginApi = "https://openapi.naver.com/v1/nid/me"
    
}
