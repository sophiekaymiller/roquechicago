//
//  ChartsViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/11/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
	
	@IBOutlet weak var number1: UISlider!
	@IBOutlet weak var number2: UISlider!
	@IBOutlet weak var number3: UISlider!
	@IBOutlet weak var pieChart: PieChartView!
	@IBOutlet weak var barChart: BarChartView!
	
	@IBAction func renderCharts() {
		barChartUpdate()
		pieChartUpdate()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Charts"
		
		barChartUpdate()
		pieChartUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func barChartUpdate () {
		let entry1 = BarChartDataEntry(x: 1.0, y: Double(number1.value))
		let entry2 = BarChartDataEntry(x: 2.0, y: Double(number2.value))
		let entry3 = BarChartDataEntry(x: 3.0, y: Double(number3.value))
		let dataSet = BarChartDataSet(values: [entry1, entry2, entry3], label: "Widgets Type")
		let data = BarChartData(dataSets: [dataSet])
		
		dataSet.colors = ChartColorTemplates.pastel()

		barChart.data = data
		barChart.chartDescription?.text = "Number of Widgets by Type"
		
		//All other additions to this function will go here
		
		//This must stay at end of function
		barChart.notifyDataSetChanged()
	}
	func pieChartUpdate () {
		
		let entry1 = PieChartDataEntry(value: Double(number1.value), label: "Haircut")
		let entry2 = PieChartDataEntry(value: Double(number2.value), label: "Blowout")
		let entry3 = PieChartDataEntry(value: Double(number3.value), label: "Hair Color")
		let dataSet = PieChartDataSet(values: [entry1, entry2, entry3], label: "Services")
		let data = PieChartData(dataSet: dataSet)
		pieChart.data = data
		pieChart.chartDescription?.text = "Percentage of Services by Type"
		
		dataSet.colors = ChartColorTemplates.pastel()
		
		//All other additions to this function will go here
		
		//This must stay at end of function
		pieChart.notifyDataSetChanged()
		
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
