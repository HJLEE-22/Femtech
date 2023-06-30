//
//  FoodApiManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import UIKit

// 별도의 Data Manager 객체로 관리해 재사용 가능
struct FoodDataManager {
    
    static let shared = FoodDataManager()
    private init() {}
        
    var url:String = "\(NetworkNames.FOOD_CATEGORY_URL_DEV)"
    
    func fetchFood(id: String, completion:  @escaping ([Food.FoodResult]) -> Void ){
        let urlString = "\(self.url)\(id)"
        guard let url = URL(string: urlString) else {
            print("DEBUG: URL error")
            return
        }
        self.dataTaskWithUrl(with: url) { foodList in
            completion(foodList)
        }
    }
    
    private func dataTaskWithUrl(with url: URL, completion: @escaping (([Food.FoodResult]) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse ,(200 ..< 299) ~= response.statusCode else
            {
                print("DEBUG: Response failed during dataTask.")
                return
            }
            guard error == nil else {
                print("DEBUG: \(error)")
                return
            }
            guard let data else {
                print("DEBUG: no data")
                return
            }
            do {
                let foodArray = try JSONDecoder().decode(Food.self, from: data)
                completion(foodArray.list)
            } catch {
                print("DEBUG: \(error)")
                return
            }
            
        }.resume()
    }
}

 
