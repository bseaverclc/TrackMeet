//
//  AthletesTableViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/18/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AthletesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
     weak var delegate: DataBackDelegate?
   
    var header = "All Schools"
    var screenTitle = "Rosters"
    var allAthletes = [Athlete]()
    var eventAthletes = [Athlete]()
    var displayedAthletes = [Athlete]()
    override func viewDidLoad() {
        super.viewDidLoad()
         
            
           
        
        self.title = screenTitle
        displayedAthletes = allAthletes
        print("ViewDidLoad")
        //tableView.reloadData()
//        for a in displayedAthletes{
//            print(a.last)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view disappearing")
        if isMovingFromParent{
        self.delegate?.savePreferences(athletes: allAthletes)
            print("is moving from parent")
        }
    }
    

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return displayedAthletes.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let athlete = displayedAthletes[indexPath.row]
        cell.textLabel?.text = "\(athlete.last), \(athlete.first)"
        cell.detailTextLabel?.text = "\(athlete.school)"
        //print(athlete.grade)
        return cell
    }
    
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var selectedAthlete = displayedAthletes[indexPath.row]
//        selectedAthlete.events.append(Event(name: self.title!, level: "varsity"))
//        eventAthletes.append(selectedAthlete)
//        performSegue(withIdentifier: "backToEventSegue", sender: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToEventSegue"{
        let nvc = segue.destination as! EventEditViewController
        nvc.eventAthletes = eventAthletes
        nvc.allAthletes = allAthletes
        }
        else{
            let nvc = segue.destination as! addAthleteViewController
            nvc.displayedAthletes = displayedAthletes
            nvc.allAthletes = allAthletes
            nvc.nvc = self
           
            
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        displayedAthletes = [Athlete]()
        for a in allAthletes{
        
            if item.title == a.school{
                displayedAthletes.append(a)
            }
        }
        //self.title = item.title
        header = item.title!
        self.tableView.reloadData()
        
    }
    
   @IBAction func unwind( _ seg: UIStoryboardSegue) {
    let pvc = seg.source as! addAthleteViewController
    allAthletes = pvc.allAthletes
    displayedAthletes = pvc.displayedAthletes
    tableView.reloadData()
    print("unwinding")
    
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }

}
