//
//  Food.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/28.
//

import Foundation

struct Food: Codable {
    
    var list : [FoodResult]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
    
    struct FoodResult: Codable {
        var id : Int?
        var thumbnail_url : String?
        var content_url : String?
        var title : String?
        var title_en : String?
        var category : Category
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case thumbnail_url = "thumbnail_url"
            case content_url = "content_url"
            case title = "title"
            case title_en = "title_en"
            case category = "category"
        }
        
        struct Category : Codable {
            
            var identity : String?
            var title : String?
            var title_en : String?
            
            enum CodingKeys: String, CodingKey {
                case identity = "identity"
                case title = "title"
                case title_en = "title_en"
            }
        }
    }
}
