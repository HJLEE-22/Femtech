//
//  OnlyTableViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import SnapKit

final class OnlyTableViewController: UIViewController {
    
    // MARK: - Properties
    
    var food: [Food.FoodResult]?
    
    private let onlyTableView = OnlyTableView()
    
    private lazy var tableView = self.onlyTableView.tableView
    
    let id = "1"
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableViewDelegate()
        self.fetchFoodData(id: self.id)
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.onlyTableView
    }
    
    // MARK: - Helpers
    
    func setTableViewDelegate() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.identifier)
    }
    
    func fetchFoodData(id: String) {
        FoodDataManager.shared.fetchFood(id: id) { [weak self] foodList in
            self?.food = foodList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView Delegate, Datasource

extension OnlyTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let food = food else {
            print("DEBUG: food error")
            return 0
        }
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.identifier) as? FoodCell else {
            print("DEBUG: cell Error")
            return UITableViewCell()
        }
        guard let food = food else {
            print("DEBUG: food error")
            return UITableViewCell()
        }
        // food data 존재할 경우 food 데이터에 맞게 변환
        guard let urlString = food[indexPath.row].thumbnail_url, let url = URL(string: urlString) else { return UITableViewCell() }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.foodImageView.image = UIImage(data: data)
                }
            }
        }
        cell.foodLabel.text = food[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let food = food, let foodContentUrl = food[indexPath.row].content_url else {
            print("DEBUG: no content url at food data")
            return
        }
        let foodDetailViewController = FoodDetailViewController()
        foodDetailViewController.detailPageUrl = foodContentUrl
        self.navigationController?.pushViewController(foodDetailViewController, animated: true)
    }

}
