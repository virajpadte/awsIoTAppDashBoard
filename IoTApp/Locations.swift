//
//  Locations.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import AWSDynamoDB

class Locations: AWSDynamoDBObjectModel,AWSDynamoDBModeling {
    var Place:String?
    var Nodes:NSArray?
    var Coordinates:String?
    
    class func dynamoDBTableName() -> String {
        return "NodeRegisteration"
    }
    
    class func hashKeyAttribute() -> String {
        return "NodeID"
    }
    
}


