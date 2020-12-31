//
//  EventsTableViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    var selectedEvent : String?
    var athletes = [Athlete]()
    var meet : Meet!
   
    var selectedRow : Int = 0

    var events = [String]()
    
    //var segues = ["relay4x800", "relay4x100","m100"]
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EventsVDL")
        self.title = "\(meet.name) Events"
        
      
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent{
            performSegue(withIdentifier: "unwindToHomeSegue", sender: self)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = events[indexPath.row]
        if indexPath.row % 2 != 0{
            cell.backgroundColor = UIColor.lightGray
        }
        if meet.beenScored[indexPath.row]{
            cell.backgroundColor = UIColor.green
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent =  tableView.cellForRow(at: indexPath)?.textLabel?.text
        selectedRow = indexPath.row
        
        performSegue(withIdentifier: "editEventSegue", sender: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    // MARK: - Navigation

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var sentAthletes = [Athlete]()
        if segue.identifier != "unwindToHomeSegue"{
        let nvc = segue.destination as! EventEditViewController
            nvc.meet = meet
      
        //nvc.eventAthletes = sentAthletes
       // nvc.allAthletes = athletes
        nvc.screenTitle = selectedEvent!
            
            nvc.selectedRow = selectedRow
        
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "The events"
    }
    
 @IBAction func unwind( _ seg: UIStoryboardSegue) {
    let pvc = seg.source as! EventEditViewController
    //athletes = pvc.allAthletes
    meet = pvc.meet
    tableView.reloadData()
    //"Unwind to events table"
}
}
