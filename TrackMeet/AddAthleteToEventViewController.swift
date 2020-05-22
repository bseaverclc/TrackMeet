//
//  AddAthleteToEventViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/20/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AddAthleteToEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarOutlet: UITabBar!
        var screenTitle = "All Schools"
        var allAthletes = [Athlete]()
        var eventAthletes = [Athlete]()
        var displayedAthletes = [Athlete]()
        
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = screenTitle
            displayedAthletes = allAthletes
           
        }
    
    override func viewWillDisappear(_ animated: Bool) {
      
        if let selectedPaths = tableView.indexPathsForSelectedRows{
            print(selectedPaths)
            for path in selectedPaths{
                var selectedAthlete = displayedAthletes[path.row]
                selectedAthlete.events.append(Event(name: self.title!, level: "varsity"))
                eventAthletes.append(selectedAthlete)
            }
        }
        if isMovingFromParent{
               performSegue(withIdentifier: "unwindToEventEdit", sender: self)
              }
    }
        
        override func viewDidAppear(_ animated: Bool) {
            tableView.reloadData()
        }
        

        // MARK: - Table view data source

        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
            print("number of sections being called")
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
        
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Did select row at")
            var selectedAthlete = displayedAthletes[indexPath.row]
            if eventAthletes.contains(where: { $0.equals(other: selectedAthlete)}) {
                var alert = UIAlertController(title: "Error!", message: "Athlete already in event", preferredStyle: .alert)
                var action = UIAlertAction(title: "ok", style: .cancel) { (action) in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
                alert.addAction(action)
               present(alert, animated: true, completion: nil)
                
            } else {
            
            //print(selectedAthlete.first)
          
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
            self.tableView.reloadData()
            
        }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "unwindToEventEdit"{
        let nvc = segue.destination as! addAthleteViewController
        nvc.allAthletes = allAthletes
        nvc.eventAthletes = eventAthletes
        nvc.from = screenTitle
        }
        
    }

    
    
    }

