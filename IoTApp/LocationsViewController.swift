//
//  LocationsViewController.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import MapKit
import AWSDynamoDB

class LocationsViewController: UITableViewController {

    
    //instance variables:
    var placeNames = [String]()
    var nodelist = [String:[String]]()
    var selectedLocation = ""
    var nodeLocations = [CLLocationCoordinate2D]()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.30, blue:0.48, alpha:1.0)
        self.table.separatorColor = UIColor(red:0.92, green:0.49, blue:0.10, alpha:1.0)
        scanData()
        
        
    }

    func scanData(){
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let scanExpression = AWSDynamoDBScanExpression()
        
        dynamoDBObjectMapper.scan(Locations.self, expression: scanExpression).continueWith(executor: AWSExecutor.mainThread()) { (task:AWSTask) -> Any? in
            if let  results = task.result{
                for r in results.items{
                    //print(r.value(forKey: "Place") as! String)
                    //print(r.value(forKey: "Nodes"))
                    let place = r.value(forKey: "Place") as! String
                    self.placeNames.append(place)
                    self.nodelist[place] = r.value(forKey: "Nodes") as? [String]
                    //print(self.nodelist)
                    let stringCoordinatesPairs = r.value(forKey: "Coordinates") as! String
                    print(stringCoordinatesPairs)
                    //command seperate into lat and long and then cast to double to get coordinate double pairs
                    var splitStringCoordinatesPairs  = stringCoordinatesPairs.components(separatedBy: ",")
                    //create a CLLocationCoordinate2D array and then add to the nodeLocations array
                    self.nodeLocations.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(splitStringCoordinatesPairs[0])!), longitude: CLLocationDegrees(Float(splitStringCoordinatesPairs[1])!)))
                }
                print(self.nodeLocations)
                self.table.reloadData()
            }
            else{
                print("Error occured!")
                //recurssion
                self.scanData()
            }
            return nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell", for: indexPath)
        cell.textLabel?.text = placeNames[indexPath.row]
        cell.tintColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:0.5)
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation = (table.cellForRow(at: indexPath)?.textLabel?.text)!
        performSegue(withIdentifier: "toNodeList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass value
        if (segue.identifier == "toNodeList"){
            let destination = segue.destination as? NodesViewController
            destination?.nodesList = nodelist[selectedLocation]!
        }
        else{
            let destination = segue.destination as? MapViewController
            destination?.nodeLocations = nodeLocations
            destination?.placeNames = placeNames
        }
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logoutRequested(_ sender: Any) {
        //show an alert
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelled) in
            print("logout cancelled")
        }))
        alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (loggedOut) in
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }))
        self.present(alert, animated: true)
    }
}
