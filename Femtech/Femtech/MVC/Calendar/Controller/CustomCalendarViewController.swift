//
//  CustomCalendarViewController.swift
//  Femtech
//
//  Created by Lee on 2023/07/18.
//

import SnapKit

final class CustomCalendarViewController: UIViewController {
    
    // MARK: - Properties
        // MARK: - Date() 관련
    struct YearAndMonth {
        var year: Int
        var month: Int
    }
    private var numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    // current는 기기 locale의 현재 Date(), presented는 화면에 보여지는 중간 CollectionView를 위한 Date().
    private var currentDay = Calendar.current.component(.day, from: Date())
    private var currentYear: Int = Calendar.current.component(.year, from: Date())
    private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    private var presentedYear = 0
    private var presentedMonth = 0
    private var previousMonth: Int = 0
    private var previousYear: Int = 0
    private var nextMonth: Int = 0
    private var nextYear: Int = 0
    // weekday는 한 주를 기준으로 해당 날짜가 몇 번째인지 표기하는 것.
    // 즉 이 변수는 한 달의 1일이 첫번째 주의 몇 번째 위치하는지 구하기
    private var firstWeekdayOfPreviousMonth: Int = 0
    private var firstWeekdayOfPresentedMonth: Int = 0
    private var firstWeekdayOfNextMonth: Int = 0
    
        // MARK: - UI 관련
    private lazy var tabbarHeight = tabBarController?.tabBar.frame.height
    private lazy var topSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top
    private lazy var mainViewHeight: CGFloat = {
        guard let tabbarHeight, let topSafeAreaHeight  else {
            print("DEBUG: tabbar Height calculate error")
            return 0
        }
        let height = self.view.bounds.height - tabbarHeight - self.monthTitleViewHeight - topSafeAreaHeight - self.weekdayTitleViewHeight
        return height
    }()
    
    private let monthTitleView = MonthTitleView()
    private let weekdayTitleView = WeekdayTitleView()
    private let monthTitleViewHeight: CGFloat = 50
    private let weekdayTitleViewHeight: CGFloat = 30
    
    private lazy var previousCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FullDateCollectionViewCell.self, forCellWithReuseIdentifier: FullDateCollectionViewCell.identifier)
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
    }()
    private lazy var presentCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FullDateCollectionViewCell.self, forCellWithReuseIdentifier: FullDateCollectionViewCell.identifier)
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
    }()
    private lazy var nextCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FullDateCollectionViewCell.self, forCellWithReuseIdentifier: FullDateCollectionViewCell.identifier)
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
    }()
    
        // MARK: - Scroll 관련
    private lazy var calendarScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    enum ScrollDirection {
        case left
        case right
        case none
    }
    private var scrollDirection: ScrollDirection = .none
    
        // MARK: - Pan Gesture 관련
    enum CalendarMode {
        case full
        case half
    }
    private var calendarMode: CalendarMode = .full
    // 이동시키는 객체의 CGPoint 값
    private var viewTransition = CGPoint(x: 0, y: 0)
    // 팬 제스쳐의 방향 CGPoint 값
    private var viewVelocity = CGPoint(x: 0, y: 0)
    private lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.changeCalendarHeight))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue()
        self.setSubviews()
        self.setLayout()
        self.loadDates(date: YearAndMonth(year: self.currentYear, month: self.currentMonth))
        self.view.addGestureRecognizer(self.scopeGesture)
    }
    
    // MARK: - Helpers
        // MARK: - Date() 처리 관련
    private func loadDates(date: YearAndMonth) {
        self.presentedYear = date.year
        self.presentedMonth = date.month
        self.previousYear = self.getPreviousDate(year: self.presentedYear, month: self.presentedMonth).year
        self.previousMonth = self.getPreviousDate(year: self.presentedYear, month: self.presentedMonth).month
        self.nextYear = self.getNextDate(year: self.presentedYear, month: self.presentedMonth).year
        self.nextMonth = self.getNextDate(year: self.presentedYear, month: self.presentedMonth).month
        // extention 세팅을 이용해 매달 1일의 위치를 구해 저장
        self.firstWeekdayOfPresentedMonth = self.getPresentedFirstWeekday()
        self.firstWeekdayOfPreviousMonth = self.getPreviousFirstWeekday()
        self.firstWeekdayOfNextMonth = self.getNextFirstWeekday()
        // 윤달 계산 후 해당 월일수 계산
        if self.presentedMonth == 2 && self.presentedYear % 4 == 0 {
            self.numberOfDaysInMonth[presentedMonth - 1] = 29
        }
        self.monthTitleView.yearAndMonthText = String(presentedYear) + "." + String(presentedMonth)
    }
    
//    private func getCurrentFirstWeekday() -> Int {
//        return ("\(currentYear)-\(currentMonth)-01".date?.firstdayOfMonth.weekday)!
//    }
    
    private func getPresentedFirstWeekday() -> Int {
        return ("\(presentedYear)-\(presentedMonth)-01".date?.firstdayOfMonth.weekday)!
    }
    private func getPreviousFirstWeekday() -> Int {
        return ("\(previousYear)-\(previousMonth)-01".date?.firstdayOfMonth.weekday)!
    }
    private func getNextFirstWeekday() -> Int {
        return ("\(nextYear)-\(nextMonth)-01".date?.firstdayOfMonth.weekday)!
    }
    private func getPreviousDate(year: Int, month: Int) -> YearAndMonth {
        var changedYear: Int = 0
        var changedMonth: Int = 0
        if month == 1 {
            changedYear = year - 1
            changedMonth = 12
        } else {
            changedYear = year
            changedMonth = month - 1
        }
        return YearAndMonth(year: changedYear, month: changedMonth)
    }
    private func getNextDate(year: Int, month: Int) -> YearAndMonth {
        var changedYear: Int = 0
        var changedMonth: Int = 0
        if month == 12 {
            changedYear = year + 1
            changedMonth = 1
        } else {
            changedYear = year
            changedMonth = month + 1
        }
        return YearAndMonth(year: changedYear, month: changedMonth)
    }
    private func updateCalendarView(new date: YearAndMonth) {
        self.loadDates(date: date)
        // collectionView의 내용이 변하기 때문에 reloadData
        self.presentCalendarCollectionView.reloadData()
        self.previousCalendarCollectionView.reloadData()
        self.nextCalendarCollectionView.reloadData()
        // 업데이트 후에도 캘린더 위치 가운데(해당달 컬렉션뷰)로 조정
        let secondXPosition = self.view.frame.width * CGFloat(1)
        self.calendarScrollView.setContentOffset(CGPoint(x: secondXPosition, y: 0), animated: false)
    }
    
        // MARK: - UI 기본 세팅
    private func setValue() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    
    private func setSubviews() {
        [self.monthTitleView, self.weekdayTitleView, self.calendarScrollView].forEach { self.view.addSubview($0) }
    }
    
    private func setLayout() {
        self.monthTitleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.monthTitleViewHeight)
        }
        self.weekdayTitleView.snp.makeConstraints { make in
            make.top.equalTo(self.monthTitleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.weekdayTitleViewHeight)
        }
        self.calendarScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.weekdayTitleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.mainViewHeight)
        }

        let screenSizeWidth = UIScreen.main.bounds.width
        self.calendarScrollView.contentSize = CGSize(width: screenSizeWidth * 3,
                                                     height: mainViewHeight)
        
        let previousXPosition = self.view.frame.width * CGFloat(0)
        self.previousCalendarCollectionView.frame = CGRect(x: previousXPosition,
                                                           y: 0,
                                                           width: screenSizeWidth,
                                                           height: mainViewHeight)
        self.calendarScrollView.addSubview(self.previousCalendarCollectionView)
        let presentXPosition = self.view.frame.width * CGFloat(1)
        self.presentCalendarCollectionView.frame = CGRect(x: presentXPosition,
                                                          y: 0,
                                                          width: screenSizeWidth,
                                                          height: mainViewHeight)
        self.calendarScrollView.addSubview(self.presentCalendarCollectionView)
        let nextXPosition = self.view.frame.width * CGFloat(2)
        self.nextCalendarCollectionView.frame = CGRect(x: nextXPosition,
                                                       y: 0,
                                                       width: screenSizeWidth,
                                                       height: mainViewHeight)
        self.calendarScrollView.addSubview(self.nextCalendarCollectionView)
        calendarScrollView.setContentOffset(CGPoint(x: presentXPosition, y: 0),
                                            animated: false)
    }
    
        // MARK: -  UI 변화 세팅
    @objc private func changeCalendarHeight(_ sender: UIPanGestureRecognizer) {
        
        self.viewTransition = sender.translation(in: self.calendarScrollView)
        self.viewVelocity = sender.velocity(in: self.calendarScrollView)
        
        switch sender.state {
        case .changed:
            if self.viewVelocity.y < 0 && self.calendarScrollView.frame.height == self.mainViewHeight {
                self.calendarMode = .half
                self.calendarScrollView.snp.updateConstraints { make in
                    make.height.equalTo(self.mainViewHeight / 2)
                }
                self.calendarScrollView.contentSize.height = self.mainViewHeight / 2
                UIView.animate(withDuration: 0.3) {
                    self.presentCalendarCollectionView.collectionViewLayout.invalidateLayout()
                    self.previousCalendarCollectionView.collectionViewLayout.invalidateLayout()
                    self.nextCalendarCollectionView.collectionViewLayout.invalidateLayout()
                }
            } else if self.viewVelocity.y > 0 && self.calendarScrollView.frame.height == self.mainViewHeight / 2 {
                self.calendarMode = .full
                self.calendarScrollView.snp.updateConstraints { make in
                    make.height.equalTo(self.self.mainViewHeight)
                }
                self.calendarScrollView.contentSize.height = self.mainViewHeight
                UIView.animate(withDuration: 0.3) {
                    self.presentCalendarCollectionView.collectionViewLayout.invalidateLayout()
                    self.previousCalendarCollectionView.collectionViewLayout.invalidateLayout()
                    self.nextCalendarCollectionView.collectionViewLayout.invalidateLayout()
                }
            }
            break
        case .ended:
            break
        default:
            break
        }
    }
}

// MARK: - CollectionView Extentions
extension CustomCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.previousCalendarCollectionView {
            let minimumCellNumber = self.numberOfDaysInMonth[self.previousMonth - 1] + self.firstWeekdayOfPreviousMonth - 1
            let dateNumber = minimumCellNumber % 7 == 0 ? minimumCellNumber : minimumCellNumber + (7 - (minimumCellNumber % 7))
            return dateNumber
        } else if collectionView == self.nextCalendarCollectionView {
            let minimumCellNumber = self.numberOfDaysInMonth[self.nextMonth - 1] + self.firstWeekdayOfNextMonth - 1
            let dateNumber = minimumCellNumber % 7 == 0 ? minimumCellNumber : minimumCellNumber + (7 - (minimumCellNumber % 7))
            return dateNumber
        } else {
            let minimumCellNumber = self.numberOfDaysInMonth[self.presentedMonth - 1] + self.firstWeekdayOfPresentedMonth - 1
            let dateNumber = minimumCellNumber % 7 == 0 ? minimumCellNumber : minimumCellNumber + (7 - (minimumCellNumber % 7))
            return dateNumber
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullDateCollectionViewCell.identifier, for: indexPath) as? FullDateCollectionViewCell else {
            return UICollectionViewCell()
        }
        // 차후 calendarMode 값을 통해 데이터를 어떻게 줄 지 변화 가능
        if collectionView == self.previousCalendarCollectionView {
            let startWeekdayOfMonth = self.firstWeekdayOfPreviousMonth - 1
            let minimumCellNumber = self.numberOfDaysInMonth[self.previousMonth - 1] + self.firstWeekdayOfPreviousMonth - 1
            
            if indexPath.item < startWeekdayOfMonth {
                let previousMonth = self.previousMonth < 2 ? 12 : self.previousMonth - 1
                let previousMonthDate = self.numberOfDaysInMonth[previousMonth - 1]
                let date = previousMonthDate - (startWeekdayOfMonth - 1) + indexPath.row
                cell.configureDate(to: date)
                cell.isPreviousMonthDate()
            } else if indexPath.item >= minimumCellNumber {
                let date = indexPath.item - minimumCellNumber + 1
                cell.configureDate(to: date)
                cell.isFollowingMonthDate()
            } else {
                let date = indexPath.row - startWeekdayOfMonth + 1
                cell.configureDate(to: date)
                cell.isCurrentMonthDate()
            }
            return cell
        } else if collectionView == self.nextCalendarCollectionView {
            let startWeekdayOfMonth = self.firstWeekdayOfNextMonth - 1
            let minimumCellNumber = self.numberOfDaysInMonth[self.nextMonth - 1] + self.firstWeekdayOfNextMonth - 1
            
            if indexPath.item < startWeekdayOfMonth {
                let previousMonth = self.nextMonth < 2 ? 12 : self.nextMonth - 1
                let previousMonthDate = self.numberOfDaysInMonth[previousMonth - 1]
                let date = previousMonthDate - (startWeekdayOfMonth - 1) + indexPath.row
                cell.configureDate(to: date)
                cell.isPreviousMonthDate()
            } else if indexPath.item >= minimumCellNumber {
                let date = indexPath.item - minimumCellNumber + 1
                cell.configureDate(to: date)
                cell.isFollowingMonthDate()
            } else {
                let date = indexPath.row - startWeekdayOfMonth + 1
                cell.configureDate(to: date)
                cell.isCurrentMonthDate()
            }
            return cell
        } else {
            let startWeekdayOfMonth = self.firstWeekdayOfPresentedMonth - 1
            let minimumCellNumber = self.numberOfDaysInMonth[self.presentedMonth - 1] + self.firstWeekdayOfPresentedMonth - 1
            
            if indexPath.item < startWeekdayOfMonth {
                let previousMonth = self.presentedMonth < 2 ? 12 : self.presentedMonth - 1
                let previousMonthDate = self.numberOfDaysInMonth[previousMonth - 1]
                let date = previousMonthDate - (startWeekdayOfMonth - 1) + indexPath.row
                cell.configureDate(to: date)
                cell.isPreviousMonthDate()
            } else if indexPath.item >= minimumCellNumber {
                let date = indexPath.item - minimumCellNumber + 1
                cell.configureDate(to: date)
                cell.isFollowingMonthDate()
            } else {
                let date = indexPath.row - startWeekdayOfMonth + 1
                cell.configureDate(to: date)
                cell.isCurrentMonthDate()
            }
            return cell
        }
    }
}

extension CustomCalendarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(calendarScrollView.frame.width / 7)
        let height = Int(calendarScrollView.frame.height) / 6
        return CGSize(width: width, height: height)
    }
}
// MARK: - ScrollView Extentions
extension CustomCalendarViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch targetContentOffset.pointee.x {
        case .zero:
            self.scrollDirection = .left
        case self.view.frame.width * CGFloat(1):
            self.scrollDirection = .none
            break
        case self.view.frame.width * CGFloat(2):
            self.scrollDirection = .right
            break
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDirection {
        case .left:
            let previousYear = self.getPreviousDate(year: self.presentedYear, month: self.presentedMonth).year
            let previousMonth = self.getPreviousDate(year: self.presentedYear, month: self.presentedMonth).month
            self.updateCalendarView(new: YearAndMonth(year: previousYear, month: previousMonth))
        case .none:
            break
        case .right:
            let nextYear = self.getNextDate(year: self.presentedYear, month: self.presentedMonth).year
            let nextMonth = self.getNextDate(year: self.presentedYear, month: self.presentedMonth).month
            self.updateCalendarView(new: YearAndMonth(year: nextYear, month: nextMonth))
        }
    }
}

// MARK: - Gesture Extentions
extension CustomCalendarViewController: UIGestureRecognizerDelegate {
    
}


