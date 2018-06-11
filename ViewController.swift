//
//  ViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/7/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseUI
import Firebase

class ViewController: UIViewController {

	@IBOutlet weak var monthLabel: UILabel!
	@IBOutlet weak var weekViewStack: UIStackView!
	@IBOutlet var numbers: [UIButton]!
	@IBOutlet var headerss: [UIButton]!
	@IBOutlet var directions: [UIButton]!
	@IBOutlet var outDates: [UIButton]!
	@IBOutlet var inDates: [UIButton]!
	
	var numberOfRows = 6
	let formatter = DateFormatter()
	var testCalendar = Calendar.current
	var generateInDates: InDateCellGeneration = .forAllMonths
	var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
	var prePostVisibility: ((CellState, CellView?)->())?
	var hasStrictBoundaries = true
	let firstDayOfWeek: DaysOfWeek = .monday
	let disabledColor = UIColor.lightGray
	let enabledColor = UIColor.blue
	let dateCellSize: CGFloat? = nil
	var monthSize: MonthSize? = nil
	var prepostHiddenValue = false
	
	let red = UIColor.red
	let white = UIColor.white
	let black = UIColor.black
	let gray = UIColor.gray
	let shade = UIColor(colorWithHexValue: 0x4E4E4E)
	

	
	//Calendar Declaration
	@IBOutlet weak var calendarView: JTAppleCalendarView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		calendarView.register(UINib(nibName: "PinkSectionHeaderView", bundle: Bundle.main),
							  forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
							  withReuseIdentifier: "PinkSectionHeaderView")
		
		
		self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
			self.setupViewsOfCalendar(from: visibleDates)
		
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func scrollNone(_ sender: Any) {
		calendarView.scrollingMode = .none
	}
	
	@IBAction func scrollFixed(_ sender: Any) {
		calendarView.scrollingMode = .stopAtEachSection
	}
	
	func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
		handleCellSelection(view: cell, cellState: cellState)
		handleCellTextColor(view: cell, cellState: cellState)
		prePostVisibility?(cellState, cell as? CellView)
	}
	
	func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
		guard let myCustomCell = view as? CellView else {return }
		//        switch cellState.selectedPosition() {
		//        case .full:
		//            myCustomCell.backgroundColor = .green
		//        case .left:
		//            myCustomCell.backgroundColor = .yellow
		//        case .right:
		//            myCustomCell.backgroundColor = .red
		//        case .middle:
		//            myCustomCell.backgroundColor = .blue
		//        case .none:
		//            myCustomCell.backgroundColor = nil
		//        }
		//
		if cellState.isSelected {
			myCustomCell.selectedView.layer.cornerRadius =  13
			myCustomCell.selectedView.isHidden = false
		} else {
			myCustomCell.selectedView.isHidden = true
		}
	}
	
	// Function to handle the text color of the calendar
	func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
		guard let myCustomCell = view as? CellView  else {
			return
		}
		
		if cellState.isSelected {
			myCustomCell.dayLabel.textColor = white
		} else {
			if cellState.dateBelongsTo == .thisMonth {
				myCustomCell.dayLabel.textColor = black
			} else {
				myCustomCell.dayLabel.textColor = gray
			}
		}
	}
	
	@IBAction func headers(_ sender: UIButton) {
		for aButton in headerss {
			aButton.tintColor = disabledColor
		}
		sender.tintColor = enabledColor
		
		if sender.title(for: .normal)! == "HeadersOn" {
			monthSize = MonthSize(defaultSize: 50, months: [75: [.feb, .apr]])
		} else {
			monthSize = nil
		}
		calendarView.reloadData()
	}

	
	@IBAction func printSelectedDates() {
		print("\nSelected dates --->")
		for date in calendarView.selectedDates {
			print(formatter.string(from: date))
		}
	}
	
	@IBAction func resize(_ sender: UIButton) {
		
		
		calendarView.frame = CGRect(
			x: calendarView.frame.origin.x,
			y: calendarView.frame.origin.y,
			width: calendarView.frame.width,
			height: calendarView.frame.height - 50
		)
		
		let date = calendarView.visibleDates().monthDates.first!.date
		calendarView.reloadData(withanchor: date)
	}
	
	@IBAction func reloadCalendar(_ sender: UIButton) {
		let date = Date()
		calendarView.reloadData(withanchor: date)
	}
	
	@IBAction func toggleStrictBoundary(sender: UIButton) {
		hasStrictBoundaries = !hasStrictBoundaries
		if hasStrictBoundaries {
			sender.tintColor = enabledColor
		} else {
			sender.tintColor = disabledColor
		}
		calendarView.reloadData()
	}
	
	@IBAction func next(_ sender: UIButton) {
		self.calendarView.scrollToSegment(.next)
	}
	
	@IBAction func previous(_ sender: UIButton) {
		self.calendarView.scrollToSegment(.previous)
	}
	
	func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
		guard let startDate = visibleDates.monthDates.first?.date else {
			return
		}
		let month = testCalendar.dateComponents([.month], from: startDate).month!
		let monthName = DateFormatter().monthSymbols[(month-1) % 12]
		// 0 indexed array
		let year = testCalendar.component(.year, from: startDate)
		monthLabel.text = monthName + " " + String(year)
	}
	
	@IBAction func showOutsideHeaders(_ sender: UIButton) {
		monthLabel.isHidden = false
		weekViewStack.isHidden = false
	}
	@IBAction func hideOutsideHeaders(_ sender: UIButton) {
		monthLabel.isHidden = true
		weekViewStack.isHidden = true
	}

}

extension ViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
	
	func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy MM dd"
		
		let startDate = formatter.date(from: "\(formatter)!") // You can use date generated from a formatter
		let endDate = Date()
		// You can also use dates created from this function
		let parameters = ConfigurationParameters(startDate: startDate!,
												 endDate: endDate,
												 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
			calendar: Calendar.current,
			generateInDates: .forAllMonths,
			generateOutDates: .tillEndOfGrid,
			firstDayOfWeek: .sunday)
		return parameters
	}
	
	func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
		// This function should have the same code as the cellForItemAt function
		let myCustomCell = cell as! CellView
		sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
	}
	
	func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
		let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
		sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
		return myCustomCell
	}
	
	func sharedFunctionToConfigureCell(myCustomCell: CellView, cellState: CellState, date: Date) {
		myCustomCell.dayLabel.text = cellState.text
		if testCalendar.isDateInToday(date) {
			myCustomCell.backgroundColor = red
		} else {
			myCustomCell.backgroundColor = white
		}
		// more code configurations
		// ...
		// ...
		// ...
	}
	

	func configureVisibleCell(myCustomCell: CellView, cellState: CellState, date: Date) {
		myCustomCell.dayLabel.text = cellState.text
		if testCalendar.isDateInToday(date) {
			myCustomCell.backgroundColor = red
		} else {
			myCustomCell.backgroundColor = white
		}
		
		handleCellConfiguration(cell: myCustomCell, cellState: cellState)
		
		
		if cellState.text == "1" {
			let formatter = DateFormatter()
			formatter.dateFormat = "MMM"
			let month = formatter.string(from: date)
			myCustomCell.monthLabel.text = "\(month) \(cellState.text)"
		} else {
			myCustomCell.monthLabel.text = ""
		}
	}
	
	func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
		let date = range.start
		let month = testCalendar.component(.month, from: date)
		
		let header: JTAppleCollectionReusableView
		if month % 2 > 0 {
			header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "WhiteSectionHeaderView", for: indexPath)
		} else {
			header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "PinkSectionHeaderView", for: indexPath)
		}
		return header
	}
	
	
	func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: CellView, date: Date, cellState: CellState) {
		let myCustomCell = cell
		// Setup Cell text
		myCustomCell.dayLabel.text = cellState.text
		
		// Setup text color
		if cellState.dateBelongsTo == .thisMonth {
			myCustomCell.dayLabel.textColor = UIColor.black
		} else {
			myCustomCell.dayLabel.textColor = UIColor.gray
		}
	}
}

extension UIColor {
	convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
		self.init(
			red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(value & 0x0000FF) / 255.0,
			alpha: alpha
		)
	}
}

