//
//  FoodViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/28.
//

import SnapKit

final class FoodViewController: UIViewController {
    
    // MARK: - Properties
    
    private var food: [Food.FoodResult]?
    
    private let foodView = FoodView()
    private let subNavigationView = SubNavigationView()
    
    private lazy var scrollView = self.foodView.scrollView
    private lazy var tableView = self.foodView.tableView
    private lazy var collectionView = self.subNavigationView.collectionView
    
    // 선택되는 셀의 indexpath를 받아 속성감시자로 데이터 변경 처리
    let id = "1"
    var selectedCellIndexPath: Int = 0 {
        didSet {
            switch selectedCellIndexPath {
            case 0:
                self.fetchFoodData(id: "1")
            case 1:
                self.fetchFoodData(id: "2")
            case 2:
                self.fetchFoodData(id: "3")
            case 3:
                self.fetchFoodData(id: "4")
            default:
                break
            }
        }
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setValue()
        self.setSubview()
        self.setLayout()
        
        self.setCollectionView()
        self.setTableViewDelegate()
        self.fetchFoodData(id: self.id)
    }

    // MARK: - Helpers
        // MARK: - 내비게이션 추가 설정
    private func setValue() {
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    private func setSubview() {
        [self.foodView, self.subNavigationView].forEach { self.view.addSubview($0) }
    }
    
    private func setLayout() {
        self.subNavigationView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        self.foodView.snp.makeConstraints { make in
            make.top.equalTo(self.subNavigationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
        // MARK: - 콜렉션뷰 설정
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SubNavigationCell.self, forCellWithReuseIdentifier: SubNavigationCell.identifier)
    }
    
    private func setTableViewDelegate() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.identifier)
    }
    
        // MARK: - 데이터매니저 객체를 통한 음식데이터 수신
    private func fetchFoodData(id: String) {
//        FoodDataManager.shared.fetchFood(id: id) { [weak self] foodList in
//            self?.food = foodList
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
        FoodDataManagerAF.shared.fetchFood(id: id) { [weak self] result in
            switch result {
            case .success(let foodList):
                self?.food = foodList
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("DEBUG: \(error)")
            }
        }
    }
}

// MARK: - TableView Delegate, Datasource

extension FoodViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let urlString = food[indexPath.row].thumbnail_url else { return UITableViewCell() }
        // kingfisher를 이용한 데이터 변환
        cell.foodImageView.setImage(with: urlString, cashSize: CGSize(width: 200, height: 200))
        // 기존 코드
//        guard let urlString = food[indexPath.row].thumbnail_url, let url = URL(string: urlString) else { return UITableViewCell() }
//        DispatchQueue.global().async {
//            if let data = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    cell.foodImageView.image = UIImage(data: data)
//                }
//            }
//        }
        cell.foodLabel.text = food[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let food = food, let foodContentUrl = food[indexPath.row].content_url else {
            print("DEBUG: no content url at food data")
            return
        }
        let foodDetailViewController = FoodDetailViewController() // 새로운 네비게이션으로 동작하게 변경
        foodDetailViewController.detailPageUrl = foodContentUrl
        self.navigationController?.pushViewController(foodDetailViewController, animated: true)
    }
}

// MARK: - CollectionView Delegate, Datasource

extension FoodViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubNavigationCell.identifier, for: indexPath) as? SubNavigationCell else {
            print("DEBUG: no cell")
            return UICollectionViewCell()
        }
        
        if indexPath.row == self.selectedCellIndexPath {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        cell.isSelected = indexPath.row == selectedCellIndexPath
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "포도당"
        case 1:
            cell.titleLabel.text = "단백질"
        case 2:
            cell.titleLabel.text = "pH"
        case 3:
            cell.titleLabel.text = "잠렬"
        default:
            break
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubNavigationCell.identifier, for: indexPath) as? SubNavigationCell else {
            print("DEBUG: no cell")
            return
        }
        self.selectedCellIndexPath = indexPath.row
    }
}

// MARK: - CollectionView FlowLayout Delegate를 통한 cell 크기 설정

extension FoodViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 4.0, height: 30)
    }
    
}
