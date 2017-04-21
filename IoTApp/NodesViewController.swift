//
//  NodesViewController.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit

class NodesViewController: UITableViewController {
    @IBOutlet var table: UITableView!

    //instance variable:
    var nodesList = [String]()
    var selectedNode = ""
    var  measuredParameter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.30, blue:0.48, alpha:1.0)
        self.table.separatorColor = UIColor(red:0.92, green:0.49, blue:0.10, alpha:0.8)
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
        return nodesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NodesCell", for: indexPath)
        cell.textLabel?.text = nodesList[indexPath.row]
        cell.tintColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:0.5)
        return cell

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNode = (table.cellForRow(at: indexPath)?.textLabel?.text)!
        switch indexPath.row {
        case 1:
            measuredParameter = "ng"
            break
        case 2:
            measuredParameter = "w"
            break
        case 3:
            measuredParameter = "ww"
            break
        default:
            measuredParameter = "elec"
        }
        performSegue(withIdentifier: "toSingleNodeView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass value
        let destination = segue.destination as? SingleNodeViewController
        destination?.selectedNode = selectedNode
        destination?.measuredParameter = measuredParameter
        print("passedValue", selectedNode)
        print("measureParameter", measuredParameter)
        
    }
    
}
