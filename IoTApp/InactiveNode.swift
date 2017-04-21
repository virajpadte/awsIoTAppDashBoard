//
//  InactiveNode.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import MapKit

class InactiveNode: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(passedCoordinates: CLLocationCoordinate2D) {
        coordinate = passedCoordinates
    }
}
