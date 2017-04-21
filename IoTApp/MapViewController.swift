//
//  MapViewController.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    //istance variables:
    var placeNames = [String]()
    var nodeLocations = [CLLocationCoordinate2D]()
    var customAnnotations = [MKAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.30, blue:0.48, alpha:1.0)
        // Do any additional setup after loading the view.
        self.map.delegate = self
        
        makeAnnotations()
        map.addAnnotations(customAnnotations)
        map.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 40.590687, longitude: -105.077576), 700, 700), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeAnnotations(){
        for (index, nodeLocation) in nodeLocations.enumerated(){
            let nodeAnnotation: ActiveNode = ActiveNode(passedCoordinate: nodeLocation)
            nodeAnnotation.title = placeNames[index]
            nodeAnnotation.subtitle = "Active"
            customAnnotations.append(nodeAnnotation)
        }
        print(customAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationReuseId = "node"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation is ActiveNode{
            annotationView?.image = #imageLiteral(resourceName: "onlineNode")
        }
        else{
            annotationView?.image = #imageLiteral(resourceName: "offlineNode")
            
        }
        //annotationView?.backgroundColor = UIColor.clearColor
        annotationView?.canShowCallout = true
        return  annotationView
    }

}
