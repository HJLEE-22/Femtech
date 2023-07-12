//
//  CalendarViewController.swift
//  Femtech
//
//  Created by Lee on 2023/07/11.
//

import SnapKit
import FSCalendar

final class CalendarViewController: UIViewController {
    
    
    // MARK: - Properties
    
//    private let calendarView = CalendarView()
    // 이동시키는 객체의 CGPoint 값
    private var viewTransition = CGPoint(x: 0, y: 0)
    // 팬 제스쳐의 방향 CGPoint 값
    private var viewVelocity = CGPoint(x: 0, y: 0)
    
    private lazy var tabbarHeight = tabBarController?.tabBar.frame.height
    private lazy var topSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top

    private lazy var mainViewHeight: CGFloat = {
        guard let tabbarHeight, let topSafeAreaHeight  else {
            print("DEBUG: tabbar Height calculate error")
            return 0
        }
        let height = self.view.bounds.height - tabbarHeight - calendarHeaderViewHeight - topSafeAreaHeight
        return height
    }()
    
    var calendar = FSCalendar()
    
    private let calendarHeaderView = CalendarHeaderView()
    private let calendarHeaderViewHeight: CGFloat = 50
    
    private var calendarTitleLabel: UILabel? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        label.text = "2023. 7"
        return label
    }
    
    private lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
//        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.changeCalendarHeight))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFSCalendarUI()
        self.setNavigationBar()
        self.view.addGestureRecognizer(self.scopeGesture)
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
    }
    
    // MARK: - Helpers

    @objc private func changeCalendarHeight(_ sender: UIPanGestureRecognizer) {
        
        self.viewTransition = sender.translation(in: view)
        self.viewVelocity = sender.velocity(in: view)
        
        switch sender.state {
        case .changed:
            if self.viewVelocity.y < 0 && self.calendar.fs_height == mainViewHeight {
                
                self.calendar.snp.updateConstraints { make in
                    make.height.equalTo(self.mainViewHeight / 2)

                }
//                self.calendar(self.calendar, boundingRectWillChange: CGRect(x: 0, y: 0, width: 100, height: Int(mainViewHeight / 2)), animated: true)
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }

            } else if self.viewVelocity.y > 0 && self.calendar.fs_height == mainViewHeight / 2 {
                self.calendar.snp.updateConstraints { make in
                    make.height.equalTo(self.mainViewHeight)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
            break
        case .ended:
            
            break
        default:
            break
        }
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setFSCalendarUI() {
        
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(self.calendarHeaderView)
        view.addSubview(calendar)
                
        calendarHeaderView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.calendarHeaderView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.mainViewHeight)
        }
        //언어설정
        calendar.locale = Locale(identifier: "ko_KR")
        // 주달/월달 설정
        calendar.scope = .month
        // 스크롤 가능/방향 설정
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        // 헤더 여부
        calendar.headerHeight = 0
        // 헤더 폰트 설정
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16)
        // Weekday 폰트 설정
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14)
        calendar.appearance.weekdayTextColor = .black
        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 14)
        // 선택된 날짜 모서리 설정
        calendar.appearance.borderRadius = 10
        // 평일 & 주말 색상 설정
        calendar.appearance.titleDefaultColor = .black  // 평일
//        calendar.appearance.titleWeekendColor = .red    // 주말
        // 다중 선택
        calendar.allowsMultipleSelection = true
        // 꾹 눌러서 드래그 동작으로 다중 선택
        calendar.swipeToChooseGesture.isEnabled = true
        // 주별 구분선
        calendar.appearance.separators = .interRows
        // 오늘날짜 표시색
        calendar.appearance.todayColor = .mainMintColor
        // 선택날짜 표시색
        calendar.appearance.selectionColor = .systemGray4
    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print(dateFormatter.string(from: date) + " 날짜가 선택되었습니다.")
    }
    // 날짜 선택 해제 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print(dateFormatter.string(from: date) + " 날짜가 선택 해제 되었습니다.")
    }

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // 공식 문서에서 레이아웃을 위해 아래의 코드 요구
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else {
            return .label
        }
    }
}

extension CalendarViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//            let velocity = self.scopeGesture.velocity(in: self.view)
//            switch self.calendar.scope {
//            case .month:
//                return velocity.y < 0
//            case .week:
//                return velocity.y > 0
//        }
//    }
}
