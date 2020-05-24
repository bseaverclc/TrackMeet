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

    var events = ["4x800 VAR", "4x800 F/S","4x100 VAR","4x100 F/S", "3200M VAR","3200M F/S","110HH VAR","110HH F/S","100M VAR","100M F/S","800 VAR","800 F/S","4x200 VAR","4x200 F/S","400 VAR","400 F/S","300IM VAR","300IM F/S","1600 VAR","1600 F/S","200M VAR","200M F/S", "4x400 VAR","4x400 F/S", "Long Jump VAR", "Long Jump F/S","Triple Jump VAR", "Triple Jump F/S","High Jump VAR", "High Jump F/S","Pole Vault VAR","Pole Vault F/S", "Shot Put VAR","Shot Put F/S", "Discus VAR","Discus F/S"]
    //var segues = ["relay4x800", "relay4x100","m100"]
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EventsVDL")

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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent =  tableView.cellForRow(at: indexPath)?.textLabel?.text
        
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
      
        //nvc.eventAthletes = sentAthletes
        nvc.allAthletes = athletes
        nvc.screenTitle = selectedEvent!
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "The events"
    }
    
 @IBAction func unwind( _ seg: UIStoryboardSegue) {
    let pvc = seg.source as! EventEditViewController
    athletes = pvc.allAthletes
    "Unwind to events table"
}
}
