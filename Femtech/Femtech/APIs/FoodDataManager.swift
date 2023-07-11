//
//  FoodApiManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import UIKit
import Alamofire

// 별도의 Data Manager 객체로 관리해 재사용 가능
struct FoodDataManager {
    
    static let shared = FoodDataManager()
    private init() {}
        
    private var url:String = "\(NetworkNames.FOOD_CATEGORY_URL_DEV)"
    
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
    
    private func dataTaskWithUrl(with url: URL, completion: @escaping ([Food.FoodResult]) -> Void) {
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

// MARK: - Alamofire 버전 Data Manager

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}
 
struct FoodDataManagerAF {
    
    static let shared = FoodDataManagerAF()
    private init() {}
    typealias NetworkCompletion = (Result<[Food.FoodResult], NetworkError>) -> Void
    private var url:String = "\(NetworkNames.FOOD_CATEGORY_URL_DEV)"
    
    func fetchFood(id: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(self.url)\(id)"
        self.performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else {
            print("DEBUG: \(urlString) : Url error occured")
            completion(.failure(.networkingError))
            return
        }

        AF.request(url).validate().response { response in
            switch response.result {
            case .success(let data):
                guard let safeData = data else {
                    completion(.failure(.dataError))
                    return
                }
                if let food = self.parseJSON(foodData: safeData) {
                    completion(.success(food))
                } else {
                    completion(.failure(.parseError))
                }
            case .failure(let error):
                print("DEBUG: \(error)")
                completion(.failure(.networkingError))
            }
        }
    }
    
    private func parseJSON(foodData: Data) -> [Food.FoodResult]? {
        do {
            let foodArray = try JSONDecoder().decode(Food.self, from: foodData)
            return foodArray.list
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            return nil
        }
    }
}



