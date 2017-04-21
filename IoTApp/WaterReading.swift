//
//  WaterReading.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import AWSDynamoDB

class WaterReading: AWSDynamoDBObjectModel,AWSDynamoDBModeling {
    var NodeID:String?
    var DataID:String?
    var Cost:String?
    var CreatedAt:String?
    var Reading:String?
    var Place:String?
    
    class func dynamoDBTableName() -> String {
        return "Water"
    }
    
    class func hashKeyAttribute() -> String {
        return "NodeID"
    }
    class func rangeKeyAttribute() -> String {
        return "CreatedAt"
    }
    
}
