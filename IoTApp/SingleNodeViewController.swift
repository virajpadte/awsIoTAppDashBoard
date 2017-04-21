//
//  SingleNodeViewController.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/21/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import AWSDynamoDB
import Charts


class SingleNodeViewController: UIViewController {
    

    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var latestReading: UILabel!
    @IBOutlet weak var latestCost: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    //instance variables:
    var selectedNode = ""
    var  measuredParameter = ""
    var readingDataArray = [Double]()
    var costDataArray = [Double]()
    var dataLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.30, blue:0.48, alpha:1.0)
        self.title = selectedNode
        nodeName.text = selectedNode
        
        // Do any additional setup after loading the view.
        configureChart()
        
    
        //get node data based on the parameter need to measured:
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        if measuredParameter == "elec"{
            
            getNodeData(objectMapper: dynamoDBObjectMapper, nodeObjectClass: EneryReading.self, nodeID: selectedNode)
            dataLabel = "Energy Consumption"
        }
        else if measuredParameter == "ng"{
            getNodeData(objectMapper: dynamoDBObjectMapper, nodeObjectClass: NaturalGasReading.self, nodeID: selectedNode)
            dataLabel = "Natural Gas Consumption"
        }
        else if measuredParameter == "w"{
            getNodeData(objectMapper: dynamoDBObjectMapper, nodeObjectClass: WaterReading.self, nodeID: selectedNode)
            dataLabel = "Water Consumption"
        }
        else if measuredParameter == "ww"{
            getNodeData(objectMapper: dynamoDBObjectMapper, nodeObjectClass: WasteWaterReading.self, nodeID: selectedNode)
            dataLabel = "WaterWater Produced"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNodeData(objectMapper: AWSDynamoDBObjectMapper, nodeObjectClass: AnyClass, nodeID: String){
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "NodeID = :nodeID"
        queryExpression.expressionAttributeValues = [
            ":nodeID" : nodeID]
        objectMapper.query(nodeObjectClass, expression: queryExpression) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as NSError? {
                print("Error: \(error)")
            } else if let nodeData = task.result{
                
                //var dataEntryCount = 0
                for item in nodeData.items{
                    print(item)
                    let readingValue = Double(item.value(forKey: "Reading") as! String)!
                    let costValue = Double(item.value(forKey: "Cost") as! String)!
                    self.readingDataArray.append(readingValue)
                    self.costDataArray.append(costValue)
                }
                //print(self.readingDataArray)
                //print(self.costDataArray)
                if self.readingDataArray.count != 0{
                    self.latestReading.text = String(format:"%f", self.readingDataArray.last!)
                    self.latestCost.text = String(format:"%f", self.costDataArray.last!)
                    //plot data on the chart
                    self.plotData(readings: self.readingDataArray)
                }
            }
            return nil
        })
    }
    
    func plotData(readings: [Double]){
        var dataEntries = [BarChartDataEntry]()
        //format data
        //plot data
        for (index,reading) in readings.enumerated(){
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(reading))
            dataEntries.append(dataEntry)
            let charDataSetLabel = dataLabel
            let charDataSet = BarChartDataSet(values: dataEntries, label: charDataSetLabel)
            charDataSet.colors = [UIColor(red:0.92, green:0.49, blue:0.10, alpha:1.0)]
            charDataSet.valueTextColor = UIColor.gray
            let chartData = BarChartData(dataSet: charDataSet)
            barChart.data = chartData
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func configureChart(){
    
        barChart.noDataText = "Where is the data"
        barChart.backgroundColor = UIColor.clear
        barChart.chartDescription?.text = ""
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.axisLineColor = UIColor.gray
        barChart.xAxis.gridColor = UIColor.gray
        barChart.xAxis.labelTextColor = UIColor.gray
        
        barChart.leftAxis.axisLineColor = UIColor.gray
        barChart.leftAxis.gridColor = UIColor.gray
        barChart.leftAxis.labelTextColor = UIColor.gray
        
        barChart.rightAxis.axisLineColor = UIColor.gray
        barChart.rightAxis.gridColor = UIColor.gray
        barChart.rightAxis.labelTextColor = UIColor.gray}



}
